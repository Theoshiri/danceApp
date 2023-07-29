import cv2

X_LABEL_START = 25
X_LABEL_END = 275
Y_LABEL = 70
Y_LABEL_SPEED = Y_LABEL + 50


class Person:
    def __init__(self, known_distance=55, known_width=14.3):
        # variables
        self.initial_time = 0
        self.initial_distance = 0
        self.changeInTime = 0
        self.changeInDistance = 0

        self.list_distance = []
        self.list_speed = []

        # distance from camera to object(body) measured
        self.known_distance = known_distance  # centimeter
        # width of body in the real world or Object Plane
        self.known_width = known_width  # centimeter
        # Colors
        self.GREEN = (0, 255, 0)
        self.RED = (0, 0, 255)
        self.WHITE = (255, 255, 255)
        self.fonts = cv2.FONT_HERSHEY_COMPLEX
        self.face_detector = cv2.CascadeClassifier("haarcascade_frontalface_default.xml")
        self.__setup_focal_legth()

    # focal length finder function

    def __setup_focal_legth(self):

        # reading reference image from directory
        ref_image = cv2.imread("ref_image.png")

        ref_image_face_width = self.face_data(ref_image)
        self.focal_length_found = self.focal_length(ref_image_face_width)

    def face_data(self, image):
        '''
        This function Detect the face
        :returns face_width in the pixels
        '''

        face_width = 0
        gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        faces = self.face_detector.detectMultiScale(gray_image, 1.3, 5)
        for (x, y, h, w) in faces:
            cv2.rectangle(image, (x, y), (x + w, y + h), self.WHITE, 1)
            face_width = w

        return face_width

    def focal_length(self, width_in_rf_image):
        """
        This Function Calculate the Focal Length(distance between lens to CMOS sensor), it is simple constant we can find
        by using MEASURED_DISTACE, REAL_WIDTH(Actual width of object) and WIDTH_OF_OBJECT_IN_IMAGE
        :param width_in_rf_image: It is object width in the frame /image in our case in the reference image(found by
        body detector)
        return Focal_Length(Float):
        """
        focal_length = (width_in_rf_image * self.known_distance) / self.known_width
        return focal_length

    def average_finder(self, complete_list, average_items):
        # finding the length of list.
        lengthOfList = len(complete_list)

        # calculating the number items to find the average of
        selectedItems = lengthOfList - average_items
        # 10 -6 =4

        # getting the list most recent items of list to find average of .
        selectedItemsList = complete_list[selectedItems:]

        # finding the average .
        average = sum(selectedItemsList) / len(selectedItemsList)

        return average

    # distance estimation function

    def distance_finder(self, focal_length, real_body_width, body_width_in_frame):
        """
    This Function simply Estimates the distance between object and camera using arguments(Focal_Length, Actual_object_width, Object_width_in_the_image)
        :param focal_length:return by the Focal_Length_Finder function
        :param real_body_width:It is Actual width of object, in real world (like My body width is = 5.7 Inches)
        :param body_width_in_frame:width of object in the image(frame in our case, using Video feed)

        :return Distance(float) : distance Estimated

    """
        distance = (real_body_width * focal_length) / body_width_in_frame
        return distance

    def draw_distance(self, distance_in_meters, image):
        cv2.line(image, (X_LABEL_START, Y_LABEL), (X_LABEL_END, Y_LABEL), (255, 0, 255), 30)
        cv2.line(image, (X_LABEL_START, Y_LABEL), (X_LABEL_END, Y_LABEL), (0, 0, 0), 22)
        cv2.putText(
            image, f"Distance = {round(distance_in_meters, 2)} m", (X_LABEL_START + 5, Y_LABEL + 5), self.fonts, 0.6,
            self.WHITE, 2)

    def calculate_distance(self, face_width_in_frame):
        Distance = self.distance_finder(
            self.focal_length_found, self.known_width, face_width_in_frame)
        self.list_distance.append(Distance)
        averageDistance = self.average_finder(self.list_distance, 2)
        # converting centimeters into meters
        distanceInMeters = averageDistance / 100
        return distanceInMeters

    def speed_finder(self, covered_distance, time_taken):
        speed = covered_distance / time_taken

        return speed

    def draw_speed(self, average_speed, image):
        # filling the progressive line dependent on the speed.
        speedFill = int(X_LABEL_START + average_speed * 130)
        if speedFill > X_LABEL_END:
            speedFill = X_LABEL_END
        cv2.line(image, (X_LABEL_START, Y_LABEL_SPEED), (X_LABEL_END, Y_LABEL_SPEED), (0, 255, 0), 35)
        # speed dependent line
        cv2.line(image, (X_LABEL_START, Y_LABEL_SPEED), (speedFill, Y_LABEL_SPEED), (255, 255, 0), 32)
        cv2.line(image, (X_LABEL_START, Y_LABEL_SPEED), (X_LABEL_END, Y_LABEL_SPEED), (0, 0, 0), 22)
        cv2.putText(
            image, f"Speed: {round(average_speed, 2)} m/s", (X_LABEL_START + 5, Y_LABEL_SPEED + 5), self.fonts,
            0.6, (0, 255, 220), 2)

    def calculate_speed(self, distanceInMeters, t):
        # finding the change in distance
        changeInDistance = self.initial_distance - distanceInMeters
        # finding change in time
        changeInTime = t - self.initial_time
        # finding the speed
        speed = self.speed_finder(
            covered_distance=changeInDistance, time_taken=changeInTime)
        self.list_speed.append(speed)
        # print('speed: ', self.list_speed)
        average_speed = self.average_finder(self.list_speed, 10)
        # print('avg speed: ', average_speed)
        if average_speed < 0:
            average_speed = average_speed * -1
        return average_speed

    def calculate_distance_speed(self, image, t):
        # finding the distance by calling function Distance
        face_width_in_frame = self.face_data(image)
        # print(face_width_in_frame)
        if face_width_in_frame != 0:
            distanceInMeters = self.calculate_distance(face_width_in_frame)
            # print(distance_in_meters)
            # Drawing Text on the screen
            self.draw_distance(distanceInMeters, image)

            if self.initial_distance != 0:
                average_speed = self.calculate_speed(distanceInMeters, t)
                self.draw_speed(average_speed, image)

            # inital distance and time
            self.initial_distance = distanceInMeters
            self.initial_time = t

        return image
