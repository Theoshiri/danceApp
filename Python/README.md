# DanceVision - Ballroom Dancing

Dance analysis app uses state-of-the-art pose-estimation technology to analyze every detail of people's ballroom dancing, including shoulder balance, hip angle, 
and distance from the camera. In addition, our advanced algorithms can track the speed of your movements as a person dance towards or away from the camera, providing 
real-time feedback on his/her performance.

![image](https://user-images.githubusercontent.com/38087342/234704889-fdadfe6f-eaa0-4c7f-ba84-44d61b1dbe40.png)

## Module 1: Python Review 1-3 weeks
- Variable
  - https://www.w3schools.com/python/python_variables.asp
  - https://www.w3schools.com/python/python_variables_names.asp
- Container
  - List
    - https://www.w3schools.com/python/python_lists.asp
    - https://www.w3schools.com/python/python_lists_access.asp
    - https://www.w3schools.com/python/python_lists_add.asp
  - Set
    - https://www.w3schools.com/python/python_sets.asp
    - https://www.w3schools.com/python/python_sets_access.asp
    - https://www.w3schools.com/python/python_sets_add.asp
  - Dictionary
    - https://www.w3schools.com/python/python_dictionaries.asp
    - https://www.w3schools.com/python/python_dictionaries_access.asp
    - https://www.w3schools.com/python/python_dictionaries_access.asp
- Functions
  - https://www.w3schools.com/python/python_functions.asp

## Module 2: Computer Vision to read a video/image
- OpenCV Get Started

  - Setup environment

  - Introduction to OpenCV

    - https://learnopencv.com/getting-started-with-opencv/
  - Process image: 
    - Run the read, display and write an image example (with an image)

      - https://learnopencv.com/read-display-and-write-an-image-using-opencv/
    - Run the image resizing example (with an image)

      - https://learnopencv.com/image-resizing-with-opencv/
    - Run the putText example 
      - https://www.geeksforgeeks.org/python-opencv-cv2-puttext-method/
  - Process video
    - Run the read, display and write an video example (with a video)
      - From File 
        - https://learnopencv.com/reading-and-writing-videos-using-opencv/
       

```
              import cv2 

              # Create a video capture object, in this case we are reading the video from a file
              vid_capture = cv2.VideoCapture('<file_path.mp4>') # For webcam change <file_path.mp4> to 0. Eg. vid_capture = cv2.VideoCapture(0)

              if (vid_capture.isOpened() == False):
                print("Error opening the video file")
              # Read fps and frame count
              else:
                # Get frame rate information
                # You can replace 5 with CAP_PROP_FPS as well, they are enumerations
                fps = vid_capture.get(5)
                print('Frames per second : ', fps,'FPS')

                # Get frame count
                # You can replace 7 with CAP_PROP_FRAME_COUNT as well, they are enumerations
                frame_count = vid_capture.get(7)
                print('Frame count : ', frame_count)

              while(vid_capture.isOpened()):
                # vid_capture.read() methods returns a tuple, first element is a bool 
                # and the second is frame
                ret, frame = vid_capture.read()
                if ret == True:
                  cv2.imshow('Frame',frame)
                  # 20 is in milliseconds, try to increase the value, say 50 and observe
                  key = cv2.waitKey(20)
                  
                  if key == ord('q'):
                    break
                else:
                  break

              # Release the video capture object
              vid_capture.release()
              cv2.destroyAllWindows()
```

## Module 3: Pose Detection Introduction

  - MediaPipe Get Started
    - Setup environment
    - Overview
      - https://google.github.io/mediapipe/solutions/pose#overview
    - Pose Landmark Model  
      - 33 pose landmarks
      ![image](https://user-images.githubusercontent.com/38087342/227323626-fa2444ef-5bb5-469f-bb85-2da661599197.png)
    - References: 
      - https://google.github.io/mediapipe/solutions/pose#pose-landmark-model-blazepose-ghum-3d
    - Run the HelloWorld example (with a video)
      - In the below you can get easily that using OpenCV we are reading the frames from the video named ‘a.mp4’ and that frames are converted from BGR to RGB image and the using mediapipe we will draw the landmarks on the entire processed frames and finally, we will get video output with landmarks as shown below. The variables ‘cTime’, ‘pTime’, and ‘fps’ are used to calculate the reading frames per second. You can see the left corner in the below output for the number of frames.

```
import cv2
import mediapipe as mp
import time

mpPose = mp.solutions.pose
pose = mpPose.Pose()
mpDraw = mp.solutions.drawing_utils

#cap = cv2.VideoCapture(0) #web cam
cap = cv2.VideoCapture('a.mp4')
pTime = 0

while True:
  success, img = cap.read()
  if success == False:
    break
  imgRGB = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
  results = pose.process(imgRGB)

  #Print the list of landmarks(x,y,z, visibility)
  print(results.pose_landmarks)
  
  if results.pose_landmarks:
    #Draw the vertices and edges between each pose landmarks
    mpDraw.draw_landmarks(img, results.pose_landmarks, mpPose.POSE_CONNECTIONS)
    
    #Draw the vertices of each pose landmarks
    for id, lm in enumerate(results.pose_landmarks.landmark):
      h, w,c = img.shape
      print(id, lm)
      cx, cy = int(lm.x*w), int(lm.y*h)
      cv2.circle(img, (cx, cy), 5, (255,0,0), cv2.FILLED)

  cTime = time.time()
  fps = 1/(cTime-pTime)
  pTime = cTime

  cv2.putText(img, str(int(fps)), (50,50), cv2.FONT_HERSHEY_SIMPLEX,1,(255,0,0), 3)
  cv2.imshow("Image", img)
  cv2.waitKey(1)

cap.release()
```
  - Output 
    
    ![image](https://user-images.githubusercontent.com/38087342/227324341-aa94c6ee-8531-4334-a722-881c03b30b6d.png)
- Analyze and learn the results (Pose Landmarks)
```
...
results = pose.process(imgRGB)
print(results.pose_landmarks)
...
```
- You can see a list of pose landmarks in the terminal section of the below image. Each landmark consists of the following:

  - x and y: These landmark coordinates normalized to [0.0, 1.0] by the image width and height respectively.

  - z: This represents the landmark depth by keeping the depth at the midpoint of hips as the origin, and the smaller the value of z, the closer the landmark is to the camera. The magnitude of z uses almost the same scale as x.

  - visibility: A value in [0.0, 1.0] indicating the probability of the landmark being visible in the image.
  ![image](https://user-images.githubusercontent.com/38087342/227325357-3bd0ab59-1645-4fa5-88b3-d47e40f820b5.png)
  
 - Deliverable:
    - Pose landmark(nose, ears, eyes, hips, shoulders...) position for each frame/image
    - Draw edges and connections between pose landmarks for each frame/image
  - References:
    - https://google.github.io/mediapipe/solutions/pose
    - https://www.analyticsvidhya.com/blog/2021/05/pose-estimation-using-opencv/
    
## Module 4 - Dance Analyzer 
- Process an image usig Mediapipe (https://github.com/cm-st-project/DanceVision-Ballroom-Dancing/blob/main/dance_analyzer.py)
  - Setup pose detection model
  
  - Draw landmarks
    - Fetch pose
  - Calculate/draw hip angles
    - Plot hip angles
      - Plot_angle
        - Calculate hip angles
        - Draw angles 
  - Calculate balance of the shoulder
    - Fetch shoulders slope
      - Calculate slope
      - Write shoulder slope
  - Calculate speed and distance of dancer's movements as he/she dances towards or away from the camera
    - Design Person class (https://github.com/cm-st-project/DanceVision-Ballroom-Dancing/blob/main/person.py)
      - Setup focal legth
      - Detect face
      - Calculate Focal length
      - Calculate distance
        - Estimates the distance between object and camera
        - Draw distance
      - Calculate speed
        - Estimates the speed
        - Draw speed
- Process a video (https://github.com/cm-st-project/DanceVision-Ballroom-Dancing/blob/main/dance_analyzer.py)
  - Setup video tool
  - Analyze video
    - Process recorded video
  - Send the analyzed video to Firebase and get the public url
    - Setup Firebase Firestore database (https://github.com/cm-st-project/DanceVision-Ballroom-Dancing/blob/main/storage_manager.py)
      - https://www.youtube.com/watch?v=UVzBQ0LkO28&ab_channel=CodeFirstwithHala
- Build a Server (https://github.com/cm-st-project/DanceVision-Ballroom-Dancing/blob/main/server.py)
  - Learn about Flask
    - Flask example 
        ```
          from flask import Flask
          app = Flask(__name__)
          @app.route('/hello/', methods=['GET', 'POST'])
          def welcome():
              return "Hello World!"
          if __name__ == '__main__':
              app.run(host='0.0.0.0')
    - Launch any web browser and go to http://localhost:5000/hello/ to see the app in action.
    Now, let’s understand the working of the code line-by-line:
      - **from flask import Flask** → Import the Flask class
      - **app = Flask(__name__)** → Create an instance of the class
      - **@app.route('/hello/', methods=['GET', 'POST'])** → We use the route() decorator to tell Flask what URL should trigger the function.
    methods specify which HTTP methods are allowed. The default is ['GET']
      - **if __name__ == '__main__'** → __name__ is a special variable in Python which takes the value of the script name. This line ensures that our Flask app runs only when it is executed in the main file and not when it is imported in some other file



