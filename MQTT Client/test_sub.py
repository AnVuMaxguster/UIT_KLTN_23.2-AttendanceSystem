import paho.mqtt.client as mqtt

def on_message(client, userdata, message):
    # userdata is the structure we choose to provide, here it's a list()
    userdata.append(message.payload)
    print(str(message.payload.decode("utf-8")))
    # We only want to process 10 messages
    # if len(userdata) >= 10:
    #     client.unsubscribe("@test_topic/")

def on_connect(client, userdata, flags, reason_code, properties):
    if reason_code.is_failure:
        print(f"Failed to connect: {reason_code}. loop_forever() will retry connection")
    else:
        # we should always subscribe from on_connect callback to be sure
        # our subscribed is persisted across reconnections.
        client.subscribe("@test_topic/")

broker_ip = "192.168.120.46"
username = "batman"
password = "brucewayne"

mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
mqttc.on_connect = on_connect
mqttc.on_message = on_message

mqttc.username_pw_set(username, password)
mqttc.user_data_set([])
mqttc.connect(broker_ip, 1883)

try:
    # Start the network loop
    mqttc.loop_forever()
    print(f"Received the following message: {mqttc.user_data_get()}")
except KeyboardInterrupt:
    # Handle keyboard interrupt
    print("Keyboard interrupt received. Disconnecting gracefully.")
    mqttc.loop_stop()  # Stop the network loop
    mqttc.disconnect()  # Disconnect from the broker