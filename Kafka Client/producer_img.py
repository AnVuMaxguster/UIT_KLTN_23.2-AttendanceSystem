import os
from confluent_kafka import Producer
import base64
from time import perf_counter

count = 0
def delivery_report(err, msg):
    if err is not None:
        print(f'Message delivery failed: {err}')
    else:
        print(f'Message delivered to {msg.topic()} [{msg.partition()}]')

def produce_img(kafka_config, topic, image_dir):
# Create Producer instance
    producer = Producer(kafka_config)

    image_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'] 
    image_paths = []

    global count

    for root, dirs, files in os.walk(image_dir):
        for file in files:
            start_time = perf_counter() # Start timer
            if any(file.lower().endswith(ext) for ext in image_extensions):
                image_path = os.path.join(root, file)

                with open(image_path, "rb") as image_file:
                    # Read the image file
                    image_data = image_file.read()
                    
                    # Encode the image data as base64
                    encoded_image = base64.b64encode(image_data)
                    
                    # Convert to string for message passing
                    encoded_image_str = encoded_image.decode('utf-8')
                    
                    # Publish the image data to Kafka topic
                    producer.produce(topic, value=encoded_image_str.encode('utf-8'), callback=delivery_report)
                    count+=1

                # Block until the messages are sent.
                producer.poll(10000)
                producer.flush()
                end_time = perf_counter()   # Stop timer
                print(f"{end_time-start_time} s")
               

if __name__ == '__main__':
    kafka_config = {
        'bootstrap.servers': '192.168.120.46:9092',
    }

    topic = "images"
    image_dir= r"D:\KLTN - Code\AnVuMaxguster-UIT_KLTN_23.2-AttendanceSystem\Kafka Client\pub_data"

    start_time = perf_counter() # Start timer
    produce_img(kafka_config, topic, image_dir)
    end_time = perf_counter()   # Stop timer
    print(f"Total: {end_time-start_time} s")
    print(f"Sent: {count}")