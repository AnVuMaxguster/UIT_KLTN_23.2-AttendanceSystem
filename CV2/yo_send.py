import cv2
import torch
import numpy as np
from confluent_kafka import Producer

import base64
import pathlib
import time
import json

pathlib.PosixPath = pathlib.WindowsPath

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

def camera_inference(model, kafka_config):
    cap = cv2.VideoCapture(0)  

    if not cap.isOpened():
        print("Error: Could not open camera.")
        exit()

    start_time = time.time()
    wait_seconds = 1

    producer = Producer(kafka_config)

    while True:
        ret, frame = cap.read()
        timestamp = int(time.time())
        cv2.imshow('USB-Cam [YOLOv5-Face Detection]', frame)

        if time.time() - start_time > wait_seconds:
            my_dict = {}
            face_byte = []

            results = model(frame, size=640) # inference

            pandas_df = results.pandas().xyxy[0]
            # print(pandas_df)
            for index, row in pandas_df.iterrows():
                xmin = int(row['xmin'])
                ymin = int(row['ymin'])
                xmax = int(row['xmax'])
                ymax = int(row['ymax'])
                cropped_image = frame[ymin:ymax, xmin:xmax]
                ret, buffer = cv2.imencode('.jpg', cropped_image)
                encoded_image = base64.b64encode(buffer)
                encoded_image_str = encoded_image.decode('utf-8')

                face_byte.append(encoded_image_str)
                    
            my_dict['data']=face_byte
            my_dict['timestamp'] = timestamp
            data_to_send = json.dumps(my_dict)
            print(data_to_send)

            producer.produce(topic, value=data_to_send, callback=delivery_report)
            producer.poll(10000)
            producer.flush()

            start_time = time.time()
        
        
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    model = load_model()

    kafka_config = {
        'bootstrap.servers': '192.168.120.46:9092',
    }
    topic = "test"

    camera_inference(model)