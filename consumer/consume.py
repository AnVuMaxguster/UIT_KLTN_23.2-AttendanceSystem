import os
from confluent_kafka import Consumer, KafkaError
import base64

def kafka_init(kafka_config, topic):
    consumer = Consumer(kafka_config)
    consumer.subscribe([topic])
    return consumer

def save_image(image_data, filename):
    with open(filename, "wb") as image_file:
        image_file.write(image_data)

def consume_image(consumer):
    count = 1
    try:
        while True:
            # Poll for new messages
            msg = consumer.poll(timeout=1.0)
            if msg is None:
                continue
            if msg.error():
                if msg.error().code() == KafkaError._PARTITION_EOF:
                    # End of partition
                    print(f"Reached end of partition {msg.topic()} [{msg.partition()}]")
                    break
                else:
                    print(f"Error: {msg.error()}")
                    break
            # Decode the base64-encoded image data
            decoded_image = base64.b64decode(msg.value().decode('utf-8'))
            filename = os.path.join(r"/home/anvu/KLTN/UIT_KLTN_23.2-AttendanceSystem/consumer/images", f"{count}.jpg")
            # Save the image to a file
            save_image(decoded_image, filename)  # Save image as received_image.jpg
            print("Image received and saved successfully.")
            count=count+1

    except KeyboardInterrupt:
        pass
    finally:
        # Leave group and commit final offsets
        print()
        print("Keyboard interrupted")
        consumer.close()

if __name__ == '__main__':
    kafka_config = {
        'bootstrap.servers': '192.168.120.46:9092',
        'group.id': '1',
        'auto.offset.reset': 'earliest'
    }

    topic = "images"
    
    consumer = kafka_init(kafka_config, topic)

    consume_image(consumer)
