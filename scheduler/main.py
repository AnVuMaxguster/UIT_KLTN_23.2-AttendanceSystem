from mqtt_subscriber import Paho_MQTT_Subcriber
from crontab import CronTab
import json
import datetime

broker_ip = "192.168.120.46"
port = 1883
username = "batman"
password = "brucewayne"

topic = "@gothamcity"

def schedule_task(start, month, day, hour, minute):
    syntax = f"{minute} {hour} {day} {month} *"
    if start:
        cron = CronTab(user='anvu')

        job = cron.new(command='/home/ubuntu/anvu/AnVuMaxguster-UIT_KLTN_23.2-AttendanceSystem/Scheduler/script.sh', comment='Publish datetime') # Set command to run & job description (comment)
        job.setall(syntax) # Set the time
        if job.is_valid():
            comment = job.comment
            print(f"Job scheduled ! Job comment: {comment}")
            cron.write()


def extract_date(start, date_str):
    # Parse the date string into a datetime object
    date_obj = datetime.datetime.strptime(date_str, "%b %d, %Y, %I:%M:%S %p")

    # Convert the datetime object to a Unix timestamp
    unix_timestamp = int(date_obj.timestamp())

    # Convert Unix timestamp to datetime object
    datetime_obj= datetime.datetime.fromtimestamp(unix_timestamp)

    # Extract each field separately (int)
    month = datetime_obj.month
    day = datetime_obj.day
    hour = datetime_obj.hour
    minute = datetime_obj.minute

    schedule_task(start, month, day, hour, minute)

def callback_func(client, userdata, message):
    json_data = json.loads(message.payload.decode("utf-8"))
    # Date string (Start)
    date_str = json_data["date_start"]
    extract_date(True, date_str)

    # Date string (End)
    date_str = json_data["date_end"]
    extract_date(False, date_str)

if __name__ == "__main__":
    mqtt_subscriber = Paho_MQTT_Subcriber(broker_ip, port, username, password)
    mqtt_subscriber.set_callback(callback_func)
    mqtt_subscriber.subcribe(topic)
    
    try:
        mqtt_subscriber.start_listening()
    except KeyboardInterrupt:
        # Handle keyboard interrupt
        print()
        print("Keyboard interrupt received. Disconnecting gracefully.")
        mqtt_subscriber.stop_listening()