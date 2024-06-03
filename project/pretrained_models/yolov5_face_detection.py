import cv2 as cv
import os
os.environ['TF_CPP_MIN_LOG_LEVEL']='2'
import torch
import pathlib

temp = pathlib.PosixPath
pathlib.PosixPath = pathlib.WindowsPath
yolomodel = torch.hub.load('ultralytics/yolov5', 'custom',path="static/best_yolov5.pt", force_reload=True)
yolomodel.to("cpu")

cap = cv.VideoCapture(0)

while cap.isOpened():
    _, frame = cap.read()
    rgb_img = cv.cvtColor(frame, cv.COLOR_BGR2RGB)
    # gray_img = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
    # faces = haarcascade.detectMultiScale(gray_img,scaleFactor=1.15,minNeighbors= 7)
    results = yolomodel(rgb_img)
    for face in results.xyxy[0]:
        xmin=int(face[0])
        ymin=int(face[1])
        xmax=int(face[2])
        ymax=int(face[3])
        cv.rectangle(frame, (xmin,ymin), (xmax,ymax), (255,0,0), 10)
        cv.putText(frame, str("face"), (xmin,ymin-10), cv.FONT_HERSHEY_SIMPLEX, 1, (0,255,0), 3, cv.LINE_AA)
            

    cv.imshow("Face detection(Yolov5)", frame)
    if cv.waitKey(1) & 0xFF == ord('q'): 
        break

cap.release()
cv.destroyAllWindows
