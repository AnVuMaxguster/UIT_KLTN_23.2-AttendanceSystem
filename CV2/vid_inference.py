import cv2
import torch
import numpy as np
import pathlib
from pathlib import Path
import time
import imutils

pathlib.PosixPath = pathlib.WindowsPath

model = torch.hub.load('ultralytics/yolov5', 'custom', path='weight/best.pt', force_reload=True)
device = 'cuda' if torch.cuda.is_available() else 'cpu'
print("\n\nDevice Used:", device)
model.to(device)
model.conf=0.7
# model.max_det=1

cap = cv2.VideoCapture("saved_vids/video.mp4")  

prev_frame_time = 0

while True:
    new_frame_time = time.time()

    ret, frame = cap.read()
    frame = imutils.resize(frame, width=640)

    results = model(frame)
    output_img = results.render()

    fps = int(1/(new_frame_time-prev_frame_time))
    prev_frame_time = new_frame_time 
    print(f"FPS: {fps}")

    cv2.imshow('USB-Cam [YOLOv5-Face Detection]', np.squeeze(output_img))

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
