import cv2
import torch
import numpy as np

import os
import shutil
import pathlib
import time

pathlib.PosixPath = pathlib.WindowsPath

def remove_directory(directory):
    shutil.rmtree(directory)

def load_model():
    model = torch.hub.load('ultralytics/yolov5', 'custom', path='weight/best.pt', force_reload=True)
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    print("\n\nDevice Used:", device)
    model.to(device)

    # Inference attributes
    model.conf=0.7
    model.max_det=1

    return model


def choose_operation(dataset_directory):
    operation = int(input("Choose operation (Create new student 1|Delete student - 2|Add more to dataset - 3| Exit - 0): "))
    if operation == 0:
        exit()
    else:
        id = int(input("ID: "))
        student_data_dir = os.path.join(dataset_directory, str(id))
        if operation == 1 or operation == 2:
            if os.path.exists(student_data_dir):
                remove_directory(student_data_dir)
                if operation == 1:
                    print("Dataset for student already exists. Deleting ...")
            if operation == 1:
                os.makedirs(student_data_dir)
        elif operation == 3:
            if not os.path.exists(student_data_dir):
                print("Dataset for student doesn't exist. Creating ...")
                os.makedirs(student_data_dir)
    return operation, student_data_dir


def get_facedata(model, student_data_dir):
    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("Error: Could not open camera.")
        exit()

    start_time = time.time()
    wait_seconds = 0.7 # Interval between applying detection on a frame (sec)

    

    start = False
    max_data = 10 # Maximum number of face data for each face angle of each student

    face_angle = "frontal"
    angle_type = 1
    text1 = f"Press s to start collecting. Angle: {face_angle}"
    color1 = (0, 0, 255)
    text2 = f"Collecting. Maximum {max_data}. Press q to stop collecting."
    color2 = (0, 255, 0)

    facedata_count = 1
    temp_count = 1

    while True:
        ret, frame = cap.read()
        if start:
            cv2.putText(frame, text2, (15,15), cv2.FONT_HERSHEY_SIMPLEX, 0.5, color2)
            if time.time() - start_time >= wait_seconds:
                results = model(frame, size=640)
                pandas_df = results.pandas().xyxy[0]
                print(pandas_df)

                if not pandas_df.empty:
                    for index, row in pandas_df.iterrows():
                        xmin = int(row['xmin'])
                        ymin = int(row['ymin'])
                        xmax = int(row['xmax'])
                        ymax = int(row['ymax'])
                        cropped_face = frame[ymin:ymax, xmin:xmax]
                        facedata_path = os.path.join(student_data_dir, f"facedata_{facedata_count}.jpg")
                        cv2.imwrite(facedata_path, cropped_face)
                        facedata_count = facedata_count + 1
                        temp_count = temp_count + 1

                        if temp_count > max_data:
                            temp_count = 1
                            start = False
                            if angle_type == 1:
                                angle_type = 2
                                face_angle = "turn left"
                            elif angle_type == 2:
                                angle_type = 3
                                face_angle = "turn right"
                            elif angle_type == 3:
                                angle_type = 4
                                face_angle = "look up"
                            elif angle_type == 4:
                                angle_type = 0
                                face_angle = "look down"
                            else:
                                angle_type = -1
                        
                            text1 = f"Press s to start collecting. Angle: {face_angle}"
                
                if angle_type == -1:
                    break

                start_time = time.time()
                    
            if (cv2.waitKey(1) & 0xFF == ord('q')):
                    break
        else:
            cv2.putText(frame, text1, (15,15), cv2.FONT_HERSHEY_SIMPLEX, 0.5, color1)
            if cv2.waitKey(1) & 0xFF == ord('s'):
                start = True

        cv2.imshow('USB-Cam', frame)

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    model = load_model()
    dataset_directory = "D:\KLTN - Code\dataset"
    while True: 
        operation, student_data_dir  = choose_operation(dataset_directory)
        # If user chooses to create/add dataset
        if operation == 1: # TO-DO: add case for operation 3
            get_facedata(model, student_data_dir) # TO-DO: add manual mode (press key to capture & detect)
