import cv2 as cv
import numpy as np
import os
os.environ['TF_CPP_MIN_LOG_LEVEL']='2'
import tensorflow as tf
from sklearn.preprocessing import LabelEncoder
import pickle
from keras_facenet import FaceNet
# import torch
# import pathlib

# temp = pathlib.PosixPath
# pathlib.PosixPath = pathlib.WindowsPath
# yolomodel = torch.hub.load('ultralytics/yolov5', 'custom',path="static/best_yolov5.pt", force_reload=True)
# yolomodel.to("cpu")

facenet = FaceNet()
faces_embeddings = np.load("faces_embeddings_done_6classes.npz")
Y = faces_embeddings['arr_1']
encoder = LabelEncoder()
encoder.fit(Y)
haarcascade = cv.CascadeClassifier("haarcascade_frontalface_default.xml")
model = pickle.load(open("svm_model_160x160_ver2.pkl", 'rb'))

cap = cv.VideoCapture(0)

while cap.isOpened():
    _, frame = cap.read()
    rgb_img = cv.cvtColor(frame, cv.COLOR_BGR2RGB)
    gray_img = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
    faces = haarcascade.detectMultiScale(gray_img,scaleFactor=1.15,minNeighbors= 7)
    # results = yolomodel(rgb_img)
    for x,y,w,h in faces:
        xmin=x
        ymin=y
        xmax=x+w
        ymax=y+h
        img = rgb_img[ymin:ymax, xmin:xmax]
        img = cv.resize(img, (160,160)) # 1x160x160x3
        img = np.expand_dims(img,axis=0)
        ypred = facenet.embeddings(img)
        face_name = model.predict(ypred)
        
        
        ypreds_proba = model.predict_proba(ypred)
        # print(ypreds_proba)
        
        ypredresult=encoder.inverse_transform(face_name)[0]
        if(ypreds_proba[0,face_name]>=0.6).any():
            print("matching face: "+ ypredresult)
            cv.rectangle(frame, (xmin,ymin), (xmax,ymax), (255,0,0), 10)
            cv.putText(frame, str(ypredresult), (xmin,ymin-10), cv.FONT_HERSHEY_SIMPLEX,
                    1, (0,255,0), 3, cv.LINE_AA)
        elif(ypreds_proba[0,face_name]>=0.5).any():
            print("matching face: "+ ypredresult)
            cv.rectangle(frame, (xmin,ymin), (xmax,ymax), (0,0,255), 10)
            cv.putText(frame, str(ypredresult+" ?"), (xmin,ymin-10), cv.FONT_HERSHEY_SIMPLEX,
                    1, (0,255,255), 3, cv.LINE_AA)
        else:
            print("no matching face found")
            cv.rectangle(frame, (xmin,ymin), (xmax,ymax), (255,0,255), 10)
            cv.putText(frame, str("????"), (xmin,ymin-10), cv.FONT_HERSHEY_SIMPLEX,
                    1, (0,0,255), 3, cv.LINE_AA)
            

    cv.imshow("Face Recognition (Haarcascade + Facenet + SVM)", frame)
    if cv.waitKey(1) & 0xFF == ord('q'): 
        break

cap.release()
cv.destroyAllWindows
