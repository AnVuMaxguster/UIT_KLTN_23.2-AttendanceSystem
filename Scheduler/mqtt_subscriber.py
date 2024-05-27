import paho.mqtt.client as mqtt
from typing import Optional

class Paho_MQTT_Subcriber:
    def on_connect(self, client, userdata, flags, reason_code, properties):
        if reason_code.is_failure:
            print(f"Failed to connect: {reason_code}. loop_forever() will retry connection")
        else:
            # we should always subscribe from on_connect callback to be sure
            # our subscribed is persisted across reconnections.
            for topic in self.topics:
                client.subscribe(topic)
            
    def __init__(self, broker_ip: str, port=1883, username: Optional[str]=None, password: Optional[str]=None):
        self.broker_ip = broker_ip
        self.port = port
        self.username = username
        self.password = password
        self.topics = []
        self.mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
        self.mqttc.on_connect = self.on_connect

    def set_callback(self, callback_func):
        self.on_message = callback_func
        self.mqttc.on_message = self.on_message

    def subcribe(self, topic):
        self.topics.append(topic)

    def start_listening(self):
        if (self.username is not None) and  (self.password is not None):
            self.mqttc.username_pw_set(self.username, self.password)
            
        self.mqttc.user_data_set([])
        self.mqttc.connect(self.broker_ip, self.port)

        self.mqttc.loop_forever()
        print(f"Received the following message: {self.mqttc.user_data_get()}")
    
    def start_listening(self):
        if (self.username is not None) and  (self.password is not None):
            self.mqttc.username_pw_set(self.username, self.password)
            
        self.mqttc.user_data_set([])
        self.mqttc.connect(self.broker_ip, self.port)
        
        self.mqttc.loop_forever()  # Start the network loop
        print(f"Received the following message: {self.mqttc.user_data_get()}")

    def stop_listening(self):
        self.mqttc.loop_stop()  # Stop the network loop
        self.mqttc.disconnect()  # Disconnect from the broker