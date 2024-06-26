import cv2 as cv
import os

import argparse
import time

from project.utilities import init_participants_dict,run_time_minutes,marking_frame_box,commit_attendance_results,final_attendance_results
from project.pretrained_models.model_methods import realtime,prepare_model
from datetime import datetime


def get_cusom_Path_from_here(filename):
    #type: (str)->str
    thisLocationFolder=os.path.dirname(os.path.abspath(__file__))
    if filename!="":return os.path.join(thisLocationFolder,filename)
    return thisLocationFolder

def main(duration:float,output:str,logs:str):
    yolo_model,facenet,svm_model,encoder=prepare_model()
    participants_array=["20521104","AnvuGei"]
    participants_dict=init_participants_dict(participants_array)
    start_time=time.time()
    runtime=0
    # cap = cv.VideoCapture(r"D:\study_source\KLTN\Kafka\python venv\kafka_venv\project\video3.mp4")
    cap = cv.VideoCapture(0)
    
    while cap.isOpened() and runtime<duration:
        _, frame = cap.read()
        rgb_img = cv.cvtColor(frame, cv.COLOR_BGR2RGB)
        # gray_img = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
        # faces = haarcascade.detectMultiScale(gray_img,scaleFactor=1.15,minNeighbors= 7)
        results=realtime(rgb_img=rgb_img,yolomodel=yolo_model,facenet=facenet,model=svm_model,encoder=encoder)
        time_elapsed=run_time_minutes(start_time)-runtime
        runtime=run_time_minutes(start_time)
        commit_attendance_results(results,participants_dict,time_elapsed)
        marking_frame_box(results,frame=frame)
                

        cv.imshow("Face Recognition (Yolov5 + Facenet + SVM)", frame)
        if cv.waitKey(1) & 0xFF == ord('q'): 
            break

    cap.release()
    cv.destroyAllWindows
    final_attendance_results(participants_dict=participants_dict,duration=duration)
    print(f"Scan started: {datetime.fromtimestamp(start_time)}\nResult: {participants_dict}")
    
if __name__=="__main__":
    default_result_filename=os.path.join(os.path.dirname(get_cusom_Path_from_here("")),"results","default_result.txt")
    default_log_directory=os.path.join(os.path.dirname(get_cusom_Path_from_here("")),"logs")
    
    logs_help=f"(OPTIONAL) set the logs folder for the run. The default folder will be {default_log_directory}"
    output_help=f"(OPTIONAL) set the output file of the result after the run had ended. The default file will be {default_result_filename}"
    
    parser=argparse.ArgumentParser(description="set property for the run")
    parser.add_argument("--duration",help="set the duration of this run in minute(s).",type=float,default=5)
    parser.add_argument("--output",help=output_help,type=str)
    parser.add_argument("--logs",help=logs_help,type=str)
    args=parser.parse_args()
    result_filename,log_directory=default_result_filename,default_log_directory
    if(args.output != None): result_filename=args.output
    if(args.logs): log_directory=args.logs
    main(args.duration,result_filename,log_directory)


