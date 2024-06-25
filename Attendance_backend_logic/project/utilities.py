import time
import cv2 as cv
from datetime import datetime
import pytz

import multiprocessing
    
def final_attendance_results(participants_dict,duration):
    #type: (dict,float)->None
    for key,raw_value in participants_dict.items():
        value=raw_value
        value["official_time"]=value["official_time"]/duration if value["official_time"]/duration<1 else 1
        participants_dict[key]=value
        
def commit_attendance_results(results,participants_dict,atb):
    #type: (dict,dict,float)->None
    
    for name,raw_value in participants_dict.items():
        value=raw_value
        if results.get(name,None)!=None:
            percents=results[name].get("matching",0)
            if percents>=0.5:
                value["official_time"]+=atb
                if value["missing_fames"]<=75:
                    value["official_time"]+=value['reserve_time']
                value["missing_fames"]=0
                value['reserve_time']=0
            else:
                value["missing_fames"]+=1
                value["reserve_time"]+=atb
        else:
            value["missing_fames"]+=1
            value["reserve_time"]+=atb
        participants_dict[name]=value
    
    # for name,value in results.items():
    #     percents=value.get("matching",0)
    #     if participants_dict.get(name,None)!=None and percents>=0.5:
    #         participants_dict[name]+=atb

def commit_ble_attendance_results(results,participants_dict,atb):
    #type: (list,dict,float)->None
    for name,value in participants_dict.items():
        if name in results:
            value["official_time"]+=atb
            if value["missing_fames"]<=2:
                value["official_time"]+=value['reserve_time']
            value["missing_fames"]=0
            value['reserve_time']=0
        else:
            value["missing_fames"]+=1
            value["reserve_time"]+=atb
            
def init_participants_dict(raw_array):
    result = {}
    for participant in raw_array:
        temp_dict={}
        temp_dict['official_time']=0
        temp_dict['missing_fames']=0
        temp_dict['reserve_time']=0
        result[participant]=temp_dict
    return result
def run_time_minutes(start_time):
    return (time.time()-start_time)/60

def run_time_minutes_from(timestamp,start_time):
    return (timestamp-start_time)/60

def extract_class_timestamps(reponse):
    #type: (dict) -> tuple[datetime,datetime]
    start_time=reponse.get("start_time",None)
    end_time=reponse.get("end_time",None)
    datetime_start=datetime.strptime(start_time,"%Y-%m-%dT%H:%M:%S.%f%z")
    datetime_end=datetime.strptime(end_time,"%Y-%m-%dT%H:%M:%S.%f%z")
    return datetime_start.replace(tzinfo=pytz.utc).astimezone(pytz.timezone('Asia/Bangkok')),datetime_end.replace(tzinfo=pytz.utc).astimezone(pytz.timezone('Asia/Bangkok'))
    
def marking_frame_box(faces,frame):
    #type: (dict,any) ->None
    for key,value in faces.items():
        xmin=value.get("xmin",0)
        ymin=value.get("ymin",0)
        xmax=value.get("xmax",0)
        ymax=value.get("ymax",0)
        percents=value.get("matching",0)
        if(percents>=0.6).any():
            print("matching face: "+ key)
            cv.rectangle(frame, (xmin,ymin), (xmax,ymax), (255,0,0), 10)
            cv.putText(frame, f"{key} {int(percents[0]*100)}%", (xmin,ymin-10), cv.FONT_HERSHEY_SIMPLEX,
                    1, (0,255,0), 3, cv.LINE_AA)
        elif(percents>=0.5).any():
            print("matching face: "+ key)
            cv.rectangle(frame, (xmin,ymin), (xmax,ymax), (0,0,255), 10)
            cv.putText(frame, str(key+" ?"), (xmin,ymin-10), cv.FONT_HERSHEY_SIMPLEX,
                    1, (0,255,255), 3, cv.LINE_AA)
        else:
            print("no matching face found")
            cv.rectangle(frame, (xmin,ymin), (xmax,ymax), (255,0,255), 10)
            cv.putText(frame, str("????"), (xmin,ymin-10), cv.FONT_HERSHEY_SIMPLEX,
                    1, (0,0,255), 3, cv.LINE_AA)
            
            
if __name__ == '__main__':
    manager = multiprocessing.Manager()
    participants_dict = manager.dict({
        'Alice': {'official_time': 0, 'missing_fames': 0, 'reserve_time': 0},
        'Bob': {'official_time': 0, 'missing_fames': 0, 'reserve_time': 0},
    })
    results = {
        'Alice': {'matching': 0.6},
        'Bob': {'matching': 0.49},
    }
    atb = 10
    # participants_dict["Alice"]["official_time"]=10
    p1=multiprocessing.Process(target=commit_attendance_results,args=(results, participants_dict, atb))
    p1.start()
    p1.join()
    print(participants_dict)