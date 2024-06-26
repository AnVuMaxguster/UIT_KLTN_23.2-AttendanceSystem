import cv2 as cv
import numpy as np
import os
os.environ['TF_CPP_MIN_LOG_LEVEL']='2'
import tensorflow as tf
from sklearn.preprocessing import LabelEncoder
import pickle
from keras_facenet import FaceNet
import torch

import tensorflow as tf
from sklearn.preprocessing import LabelEncoder
import pickle
from keras_facenet import FaceNet
import torch
os.environ['TF_CPP_MIN_LOG_LEVEL']='2'
import pathlib

def get_cusom_Path_from_here(filename):
    #type: (str)->str
    thisLocationFolder=os.path.dirname(os.path.abspath(__file__))
    if filename!="":return os.path.join(thisLocationFolder,filename)
    return thisLocationFolder

def prepare_model():
    #type: ()->tuple[any,FaceNet,any,LabelEncoder]
    temp = pathlib.PosixPath
    pathlib.PosixPath = pathlib.WindowsPath
    yolov5RelPath=os.path.join("static","yolov5_new.pt")
    yolomodel = torch.hub.load('ultralytics/yolov5', 'custom',path=get_cusom_Path_from_here(yolov5RelPath), force_reload=True)
    
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    print(f"Device: {device}")
    yolomodel.to(device)
    # yolomodel.conf=0.6
    
    # yolomodel.to("cpu")

    facenet = FaceNet()
    # faces_embeddings = np.load(get_cusom_Path_from_here("faces_embeddings_done_6classes.npz"))
    faces_embeddings = np.load(get_cusom_Path_from_here("faces_embeddings_done_classes_sample_26062024.npz"))
    Y = faces_embeddings['arr_1']
    encoder = LabelEncoder()
    encoder.fit(Y)
    # haarcascade = cv.CascadeClassifier("haarcascade_frontalface_default.xml")
    model = pickle.load(open(get_cusom_Path_from_here("svm_model_160x160_sample_26062024.pkl"), 'rb'))
    # model = pickle.load(open(get_cusom_Path_from_here("svm_model_160x160_ver2.pkl"), 'rb'))
    return yolomodel,facenet,model,encoder

def prepare_model_noyolo():
    #type: ()->tuple[any,FaceNet,any,LabelEncoder]
    temp = pathlib.PosixPath
    pathlib.PosixPath = pathlib.WindowsPath

    facenet = FaceNet()
    # faces_embeddings = np.load(get_cusom_Path_from_here("faces_embeddings_done_6classes.npz"))
    faces_embeddings = np.load(get_cusom_Path_from_here("faces_embeddings_done_classes_sample_26062024.npz"))
    Y = faces_embeddings['arr_1']
    encoder = LabelEncoder()
    encoder.fit(Y)
    # haarcascade = cv.CascadeClassifier("haarcascade_frontalface_default.xml")
    model = pickle.load(open(get_cusom_Path_from_here("svm_model_160x160_sample_26062024.pkl"), 'rb'))
    # model = pickle.load(open(get_cusom_Path_from_here("svm_model_160x160_ver2.pkl"), 'rb'))
    return facenet,model,encoder


def realtime(rgb_img,yolomodel,facenet,model,encoder):
    #type: (any,any,FaceNet,any,LabelEncoder)-> dict
    yolo_results = yolomodel(rgb_img)
    faces_result={}
    for face in yolo_results.xyxy[0]:
        result_detail={}
        xmin=int(face[0])
        ymin=int(face[1])
        xmax=int(face[2])
        ymax=int(face[3])
        img = rgb_img[ymin:ymax, xmin:xmax]
        img = cv.resize(img, (160,160)) # 1x160x160x3
        img = np.expand_dims(img,axis=0)
        ypred = facenet.embeddings(img)
        face_name = model.predict(ypred)
        
        
        ypreds_proba = model.predict_proba(ypred)
        face_matching_percent=ypreds_proba[0,face_name]
        # print(ypreds_proba)
        ypredresult=encoder.inverse_transform(face_name)[0]
        result_detail["xmin"],result_detail["ymin"],result_detail["xmax"],result_detail["ymax"],result_detail["matching"]=xmin,ymin,xmax,ymax,face_matching_percent
        faces_result[ypredresult]=result_detail
    return faces_result

def regconition_model(rgb_imgs,facenet,model,encoder):
    #type: (list,FaceNet,any,LabelEncoder)-> dict
    faces_result={}
    for img in rgb_imgs:
        # print(type(img))
        result_detail={}
        img = cv.resize(img, (160,160)) # 1x160x160x3
        img = np.expand_dims(img,axis=0)
        ypred = facenet.embeddings(img)
        face_name = model.predict(ypred)
        
        
        ypreds_proba = model.predict_proba(ypred)
        face_matching_percent=ypreds_proba[0,face_name]
        # print(ypreds_proba)
        ypredresult=encoder.inverse_transform(face_name)[0]
        result_detail["matching"]=face_matching_percent
        faces_result[ypredresult]=result_detail
    return faces_result