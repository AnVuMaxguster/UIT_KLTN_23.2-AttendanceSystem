import cv2
import torch
import numpy as np
from confluent_kafka import Producer

import os
import base64
import pathlib
import time
import shutil
import json

pathlib.PosixPath = pathlib.WindowsPath

def remove_contents(directory):
    # Walk through the directory and delete all files and directories
    for root, dirs, files in os.walk(directory, topdown=False):
        for file in files:
            file_path = os.path.join(root, file)
            os.remove(file_path)
        for dir in dirs:
            dir_path = os.path.join(root, dir)
            shutil.rmtree(dir_path)

def load_model():
    model = torch.hub.load('ultralytics/yolov5', 'custom', path='weight/best.pt', force_reload=True)
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    print("\n\nDevice Used:", device)
    model.to(device)

    # Inference attributes
    model.conf=0.8
    model.max_det=1

    return model

def delivery_report(err, msg):
    if err is not None:
        print(f'Message delivery failed: {err}')
    else:
        print(f'Message delivered to {msg.topic()} [{msg.partition()}]')


def produce_img(kafka_config, topic, image_dir, timestamp):
    # Create Producer instance
    producer = Producer(kafka_config)

    image_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'] 
    image_paths = []

    my_dict = {}
    face_byte = []

    for root, dirs, files in os.walk(image_dir):
        for file in files:
            if any(file.lower().endswith(ext) for ext in image_extensions):
                image_path = os.path.join(root, file)

                with open(image_path, "rb") as image_file:
                    # Read the image file
                    image_data = image_file.read()
                    
                    # Encode the image data as base64
                    encoded_image = base64.b64encode(image_data)
                    
                    # Convert to string for message passing
                    encoded_image_str = encoded_image.decode('utf-8')

                    face_byte.append(encoded_image_str)
                    
    my_dict['data']=face_byte
    my_dict['timestamp'] = timestamp
    data_to_send = json.dumps(my_dict)

    producer.produce(topic, value=data_to_send, callback=delivery_report)
    producer.poll(10000)
    producer.flush()

def camera_inference(model):
    cap = cv2.VideoCapture(0)  

    if not cap.isOpened():
        print("Error: Could not open camera.")
        exit()

    start_time = time.time()
    wait_seconds = 1 # Interval between applying detection on a frame (sec)

    batch_count=1
    while True:
        ret, frame = cap.read()
        timestamp = int(time.time())
        cv2.imshow('USB-Cam [YOLOv5-Face Detection]', frame)

        if time.time() - start_time > wait_seconds:
            output_directory = f"saved_images/batch_{batch_count}"
            if not os.path.exists(output_directory):
                os.makedirs(output_directory)

            results = model(frame, size=640) # inference

            pandas_df = results.pandas().xyxy[0]
            # print(pandas_df)
            face_count = 1
            for index, row in pandas_df.iterrows():
                xmin = int(row['xmin'])
                ymin = int(row['ymin'])
                xmax = int(row['xmax'])
                ymax = int(row['ymax'])
                cropped_image = frame[ymin:ymax, xmin:xmax]

                temp_path = os.path.join(output_directory, f"{face_count}_cropped_cv2.jpg")
                cv2.imwrite(temp_path, cropped_image) # TO-DO: directly convert frame in bytes without having to save it as jpg first
                face_count=face_count+1

            produce_img(kafka_config, topic, output_directory, timestamp)
            batch_count = batch_count + 1
            start_time = time.time()
        
        
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    remove_contents("saved_images/")

    model = load_model()

    kafka_config = {
        'bootstrap.servers': '192.168.120.46:9092',
    }
    topic = "test"

    camera_inference(model)

    


