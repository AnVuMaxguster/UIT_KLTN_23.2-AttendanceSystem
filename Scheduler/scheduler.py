from mqtt_subscriber import Paho_MQTT_Subcriber
from crontab import CronTab
import json
import datetime
from datetime import timezone, timedelta

broker_ip = "192.168.120.46"
port = 1883
username = "batman"
password = "brucewayne"

topic_post = "/mqtt/class/post"
topic_put = "/mqtt/class/put"
topic_del = "/mqtt/class/del"

def schedule_task(month, day, hour, minute, month_, day_, hour_, minute_, id):
    syntax = f"{minute} {hour} {day} {month} *"

    cron = CronTab(user='ubuntu')

    job = cron.new(command=f'/home/ubuntu/anvu/AnVuMaxguster-UIT_KLTN_23.2-AttendanceSystem/Scheduler/script.sh {id}', comment='Publish MQTT') # Set command to run & job description (comment)
    job.setall(syntax) # Set the time
    if job.is_valid():
        comment = job.comment
        print(f"Job scheduled ! Job comment: {comment}")
        cron.write()

def extract_date(time):
    time = time / 1000.0 # Milisec to sec
    # datetime_obj = datetime.datetime.fromtimestamp(time)

    # datetime_obj = datetime.datetime.fromtimestamp(time, tz=timezone.utc)
    
    # # Convert to GMT+7
    # datetime_obj = datetime_obj.astimezone(timezone(timedelta(hours=7)))
    
    # TESTING: input own timestamp
    datetime_obj = datetime.datetime.fromtimestamp(1718892720)

    month = datetime_obj.month
    day = datetime_obj.day
    hour = datetime_obj.hour
    minute = datetime_obj.minute

    return month,day,hour,minute

def callback_func(client, userdata, message):
    json_data = json.loads(message.payload.decode("utf-8"))

    class_id = json_data["id"]
    start_time = json_data["start_time"]
    end_time = json_data["end_time"]

    month,day,hour,minute = extract_date(start_time)
    month_,day_,hour_,minute_ = extract_date(end_time)

    print(f"{month} {day} {hour} {minute} {class_id}")

    schedule_task(month, day, hour, minute, month_, day_, hour_, minute_, class_id)

if __name__ == "__main__":
    mqtt_subscriber = Paho_MQTT_Subcriber(broker_ip, port, username, password)
    mqtt_subscriber.set_callback(callback_func)
    
    mqtt_subscriber.subcribe(topic_post)
    mqtt_subscriber.subcribe(topic_put)
    mqtt_subscriber.subcribe(topic_del)
    
    try:
        mqtt_subscriber.start_listening()
    except KeyboardInterrupt:
        # Handle keyboard interrupt
        print()
        print("Keyboard interrupt received. Disconnecting gracefully.")
        mqtt_subscriber.stop_listening()