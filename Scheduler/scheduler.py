from mqtt_client import Paho_MQTT_Subcriber
import json
import datetime

broker_ip = "192.168.120.46"
port = 1883
username = "batman"
password = "brucewayne"

topic = "@gothamcity"

def callback_func(client, userdata, message):
    ## userdata is the structure we choose to provide, here it's a list()
    # userdata.append(message.payload)
    # print(str(message.payload.decode("utf-8")))

    ## Testing on Sample JSON
    json_data = json.loads(message.payload.decode("utf-8"))
    print(json_data["name"])
    print(json_data["address"]["state"])
    print(json_data["tags"][2])


    ## Testing for UNIX data ( from JSON as well )
    # Convert Unix timestamp to datetime object
    # json_data = json.loads(message.payload.decode("utf-8"))
    # date_data = json_data["date"]
    # datetime_obj = datetime.datetime.fromtimestamp(date_data)

    # year = datetime_obj.year
    # month = datetime_obj.month
    # day = datetime_obj.day
    # hour = datetime_obj.hour
    # minute = datetime_obj.minute
    # second = datetime_obj.second

    # print("Year:", year)
    # print("Month:", month)
    # print("Day:", day)
    # print("Hour:", hour)
    # print("Minute:", minute)
    # print("Second:", second)
    
    # print()

if __name__ == "__main__":
    mqtt_subscriber = Paho_MQTT_Subcriber(broker_ip, port, username, password)
    mqtt_subscriber.set_callback(callback_func)
    mqtt_subscriber.subcribe(topic)
    
    try:
        mqtt_subscriber.start_listening()
    except KeyboardInterrupt:
        # Handle keyboard interrupt
        print("Keyboard interrupt received. Disconnecting gracefully.")
        mqtt_subscriber.stop_listening()

# Sample JSON
# {
#   "name": "John Doe",
#   "age": 30,
#   "email": "johndoe@example.com",
#   "address": {
#     "street": "123 Main St",
#     "city": "Anytown",
#     "state": "CA",
#     "zipcode": "12345"
#   },
#   "tags": ["developer", "musician", "reader"]
# }