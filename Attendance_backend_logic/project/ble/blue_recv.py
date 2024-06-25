import paho.mqtt.client as mqtt
import json
from logging import Logger
from clog import clog
import os
from datetime import datetime
import project.utilities as utilities
def raw_name_dict_to_ble_dict(raw):
    #type: (dict)->dict
    print(f"In raw_name_dict_to_ble_dict {raw}")
    formated_dict={}
    for key,value in raw.items():
        bleMac=value["bleMac"]
        if bleMac!=None:
            formated_dict[bleMac]=key
    return formated_dict

def extract_userdata(userdata):
    #type: (dict)->tuple[dict,dict,float,datetime,datetime,bool,float,Logger]
    # print(userdata)
    raw_name_dict=userdata["raw_name_dict"]
    class_member_ble_dict=raw_name_dict_to_ble_dict(raw=raw_name_dict)
    participants_dict=userdata["participants_dict"]
    class_duration=userdata["class_duration"]
    class_start_time=userdata["class_start_time"]
    class_end_time=userdata["class_end_time"]
    # logger_path=userdata["logger_path"]
    # logger=clog("P2_log",os.path.join(logger_path,"P2_log.log")).setup_logger()
    logger=userdata["logger"]
    usual_run=userdata["usual_run"]
    run_time=userdata["run_time"]
    return class_member_ble_dict,participants_dict,class_duration,class_start_time,class_end_time,usual_run,run_time,logger

def check_ble(mqtt_data,class_data):
    #type: (list,dict)->list
    # print(mqtt_data)
    result=[]
    for key,value in class_data.items():
        if key in mqtt_data:
            result.append(value)
    return result
        

def on_message(client, userdata, message):
    #type: (mqtt.Client,dict,dict) ->None
    try:
        json_data = json.loads(message.payload.decode("utf-8"))
        # print(json_data)
        # --------- DO YOUR JOB HERE ----------------
        class_member_ble_dict,participants_dict,class_duration,class_start_time,class_end_time,usual_run,run_time,logger=extract_userdata(userdata=userdata)
        logger.debug(f"Receving from Mqtt: {json_data}")
        print(f"\n\nUserdata: {userdata}")
        timestamp = float(json_data["timestamp"])
        data = json_data["device_addr"]
        if timestamp<class_start_time.timestamp():
                return
        if run_time==0 and timestamp>class_end_time.timestamp():
            client.loop_stop()
            client.disconnect()
            return
        usual_run=True
        # print(f"usual run {usual_run}")
        results=check_ble(data,class_member_ble_dict)
        time_elapsed=utilities.run_time_minutes_from(timestamp,class_start_time.timestamp())-run_time
        run_time=utilities.run_time_minutes_from(timestamp,class_start_time.timestamp())   
            
        utilities.commit_ble_attendance_results(results=results,participants_dict=participants_dict,atb=time_elapsed)
        userdata["run_time"]=run_time
        userdata["usual_run"]=usual_run
        userdata["participants_dict"]=participants_dict
        
        if run_time>=class_duration:
            # print(f"usual run {usual_run}")
            if usual_run:
                logger.debug("BLE final_checkout")
                utilities.final_attendance_results(participants_dict=participants_dict,duration=class_duration)
                logger.debug(f"BLE_participants_dict after final_commit: {participants_dict}")
                userdata["participants_dict"]=participants_dict
            client.loop_stop()
            client.disconnect()
            return
    except Exception as e:
        print(str(e.with_traceback()))
    
    
    # --------- DO YOUR JOB HERE ----------------

def on_connect(client, userdata, flags, reason_code, properties):
    if reason_code.is_failure:
        print(f"Failed to connect: {reason_code}. loop_forever() will retry connection")
    else:
        client.subscribe("@test_topic/") # TOPIC NAME HERE

def blue_init(user_data):
    #type: (dict)->mqtt.Client
    broker_ip = "192.168.120.46"
    username = "batman"
    password = "brucewayne"
    # print(user_data)
    mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2,userdata=user_data)
    mqttc.on_connect = on_connect
    mqttc.on_message = on_message

    mqttc.username_pw_set(username, password)
    # mqttc.user_data_set([])
    mqttc.connect(broker_ip, 1883)
    
    return mqttc

def blue_loop_manual(user_data):
    #type: (dict)->None
    try:
        logger_path=user_data["logger_path"]
        logger=clog("P2_log",os.path.join(logger_path,"P2_log.log")).setup_logger()
        user_data["logger"]=logger
        mqttc=blue_init(user_data=user_data)
        while True:
            mqttc.loop()
            if not mqttc.is_connected():
                break
            # print(f"Received the following message: {mqttc.user_data_get()}")
    except Exception as e :
        print(f"BLE Exception: {str(e)}")
    except KeyboardInterrupt:
        # Handle keyboard interrupt
        print("Keyboard interrupt received. Disconnecting gracefully.")
        mqttc.loop_stop()
        mqttc.disconnect()  