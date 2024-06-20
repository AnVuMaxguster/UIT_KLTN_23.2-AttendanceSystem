import cv2
import torch
import numpy as np
import pathlib
from pathlib import Path

pathlib.PosixPath = pathlib.WindowsPath

model = torch.hub.load('ultralytics/yolov5', 'custom', path='weight/best.pt', force_reload=True)
device = 'cuda' if torch.cuda.is_available() else 'cpu'
print("\n\nDevice Used:", device)
model.to(device)
model.conf=0.7
# model.max_det=1

cap = cv2.VideoCapture(0)  

if not cap.isOpened():
    print("Error: Could not open camera.")
    exit()

while True:
    ret, frame = cap.read()

    results = model(frame)
    output_img = results.render()

    cv2.imshow('USB-Cam [YOLOv5-Face Detection]', np.squeeze(output_img))

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
