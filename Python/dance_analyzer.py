import time
from pathlib import Path

import cv2
import mediapipe as mp
import numpy as np
from tqdm import tqdm

from person import Person, X_LABEL_START, X_LABEL_END
from storage_manager import StorageManager
from utils_func import resize_original, resize_image, calculate_angle, calculate_slope, remove_file

REALTIME = 0


class DanceAnalyzer:
    def __init__(self):
        self.person_found = False
        self.landmarks = None
        self.__set_up_pose_detection_model()
        self.person = Person()
        self.sm = StorageManager()

    def __set_up_pose_detection_model(self):
        self.mp_drawing = mp.solutions.drawing_utils
        self.mp_pose = mp.solutions.pose
        self.pose = self.mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5)

    def __setup_video_tool(self, cap, video_path):
        width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

        fps = 15  # Use less numb of frames to make the video slower
        if video_path == REALTIME:
            output_path = 'realtime_output.mp4'
        else:
            output_path = Path(video_path).stem + '_output.mp4'

        output_dim = (int(width), int(height))
        out = cv2.VideoWriter(output_path, cv2.VideoWriter_fourcc('m', 'p', '4', 'v'), int(fps), output_dim)
        return height, out, output_path, width

    def __fetch_pose(self, image, pose):
        # To improve performance, optionally mark the image as not writeable to
        # pass by reference.
        image.flags.writeable = False
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        results = pose.process(image)

        # Draw the pose annotation on the image.
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        return image, results

    def plot_hip_angles(self, image, h, w):

        image = self.__plot_angle(self.mp_pose.PoseLandmark.LEFT_SHOULDER.value,
                                  self.mp_pose.PoseLandmark.LEFT_HIP.value,
                                  self.mp_pose.PoseLandmark.LEFT_KNEE.value, image, h, w + 50)

        image = self.__plot_angle(self.mp_pose.PoseLandmark.RIGHT_SHOULDER.value,
                                  self.mp_pose.PoseLandmark.RIGHT_HIP.value,
                                  self.mp_pose.PoseLandmark.RIGHT_KNEE.value, image, h, w - 70)

        return image

    def __plot_angle(self, p1, p2, p3, image, h, w):

        # Get coordinates
        a = [self.landmarks[p1].x,
             self.landmarks[p1].y]
        b = [self.landmarks[p2].x, self.landmarks[p2].y]
        c = [self.landmarks[p3].x, self.landmarks[p3].y]

        # Calculate angle
        angle = calculate_angle(a, b, c)
        self.__draw_angle(tuple(np.multiply(b, [w, h]).astype(int)), image, round(angle))
        return image

    def __draw_angle(self, org: tuple, image, angle):

        # font
        font = cv2.FONT_HERSHEY_SIMPLEX
        # fontScale
        fontScale = 0.4
        # Blue color in BGR
        color = (255, 255, 255)

        # Line thickness of 1 px
        thickness = 1

        # Using cv2.putText() method
        image = cv2.putText(image, str(angle), org, font,
                            fontScale, color, thickness, cv2.LINE_AA)
        return image

    def __draw_landmarks(self, results, image):
        # do not display hand, feet
        for idx, landmark in enumerate(self.landmarks):
            if idx in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 17, 18, 19, 20, 21, 22, 29, 30, 31, 32]:
                self.landmarks[idx].visibility = 0

        self.mp_drawing.draw_landmarks(image, results.pose_landmarks, self.mp_pose.POSE_CONNECTIONS,
                                       self.mp_drawing.DrawingSpec(color=(255, 0, 0), thickness=2, circle_radius=2),
                                       self.mp_drawing.DrawingSpec(color=(245, 66, 230), thickness=2, circle_radius=2))
        return image

    def __fetch_shoulders_slope(self, image):
        l_shoulder = self.mp_pose.PoseLandmark.LEFT_SHOULDER.value
        r_shoulder = self.mp_pose.PoseLandmark.RIGHT_SHOULDER.value

        m = (calculate_slope(self.landmarks[r_shoulder].x, self.landmarks[r_shoulder].y,
                             self.landmarks[l_shoulder].x, self.landmarks[l_shoulder].y, ))

        # print(m)
        balance = 'Balance'
        if m <= 0.1:
            balance = 'Left'
        elif m >= -0.1:
            balance = 'Right'

        image = self.__write_shoulder_slope((X_LABEL_START, 25), image, round(-m, 2), balance)
        return image

    def __write_shoulder_slope(self, org: tuple, image, slope, balance):

        # font
        font = cv2.FONT_HERSHEY_SIMPLEX
        # fontScale
        fontScale = 0.6
        # Blue color in BGR
        color = (255, 255, 255)

        # Line thickness of 2 px
        thickness = 2

        cv2.line(image, (org[0] - 2, org[1]), (X_LABEL_END, org[1]), (255, 0, 255), 50)
        cv2.line(image, (org[0] - 2, org[1]), (X_LABEL_END, org[1]), (0, 0, 0), 45)
        # Using cv2.putText() method
        image = cv2.putText(image, f'Shoulders Slope: {slope}', org, font,
                            fontScale, color, thickness)
        # Using cv2.putText() method
        image = cv2.putText(image, f'Shoulders Balance: {balance}', (org[0], org[1] + 20), font,
                            fontScale, color, thickness)
        return image

    def __calculate_speed(self, image, t):
        image = self.person.calculate_distance_speed(image=image, t=t)
        return image

    def process_image(self, h, image, results, w, show_image=False):
        self.landmarks = results.pose_landmarks.landmark
        t = time.time()
        image = self.__calculate_speed(image, t)
        image = self.__fetch_shoulders_slope(image)
        image = self.plot_hip_angles(image, h, w)
        image = self.__draw_landmarks(results, image)

        if show_image:
            cv2.imshow('frame', image)
        return image

    def process_recorded_video(self, save_video, cap, out, height, width, show_image):
        n_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
        # Read until video is completed
        for i in tqdm(range(n_frames)):
            # Capture frame-by-frame
            success, image = cap.read()

            if not success:
                print("Ignoring empty camera frame.")
                # If loading a video, use 'break' instead of 'continue'.
                break

            image, h, w = resize_image(image, percent=0.7)
            image, results = self.__fetch_pose(image, self.pose)

            # Extract landmarks
            try:
                image = self.process_image(h, image, results, w, show_image)

                if save_video:
                    image = resize_original(image, height, width)
                    out.write(image)

                # Press Q on keyboard to  exit
                if cv2.waitKey(25) & 0xFF == ord('q'):
                    break
            # Break the loop
            except Exception as e:
                print(e)

    def process_realtime_video(self, save_video, cap, out, height, width, show_image):
        # Read until video is completed
        while cap.isOpened():
            # Capture frame-by-frame
            success, image = cap.read()

            if not success:
                print("Ignoring empty camera frame.")
                # If loading a video, use 'break' instead of 'continue'.
                break

            image, h, w = resize_image(image, percent=0.7)
            image, results = self.__fetch_pose(image, self.pose)

            # Extract landmarks
            try:
                image = self.process_image(h, image, results, w, show_image)

                if save_video:
                    image = resize_original(image, height, width)
                    out.write(image)

                # Press Q on keyboard to  exit
                if cv2.waitKey(25) & 0xFF == ord('q'):
                    break
            # Break the loop
            except Exception as e:
                print(e)

    def process_video(self, video_path=0, save_video=False, show_image=False):
        print('=== Process Video ===')
        output_path = None
        i = 0
        # Create a VideoCapture object and read from input file
        # If the input is the camera, pass 0 instead of the video file name
        cap = cv2.VideoCapture(video_path)

        # Check if camera opened successfully
        if not cap.isOpened():
            print("Error opening video stream or file")
        if save_video:
            height, out, output_path, width = self.__setup_video_tool(cap, video_path)

        if video_path == REALTIME:
            self.process_realtime_video(save_video, cap, out, height, width, show_image)
        else:
            self.process_recorded_video(save_video, cap, out, height, width, show_image)

        # When everything done, release the video capture object
        cap.release()
        if save_video:
            out.release()

        # Closes all the frames
        cv2.destroyAllWindows()

        print('=== Save Video ===')
        # save video in Firebase storage
        url = self.sm.upload_file(firebase_path=f'dance_ballroom/{output_path}', local_path=output_path)
        print(url)
        remove_file(output_path)

        return url
