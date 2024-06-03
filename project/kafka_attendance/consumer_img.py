import os
from confluent_kafka import Consumer, KafkaError
import base64

def save_image(image_data, filename):
    absolute_path = os.path.abspath(filename)
    with open(absolute_path, "wb") as image_file:
        image_file.write(image_data)
        
def clear_folder(folder_path):
    for file in os.listdir(folder_path):
        os.remove(
            path=os.path.abspath(
                os.path.join(folder_path,file)
            )
            )
    
def main():
    kafka_config = {
        'bootstrap.servers': '172.31.11.51:9092',
        'group.id': '1',
        'auto.offset.reset': 'earliest'
    }

    # Create Consumer instance
    consumer = Consumer(kafka_config)

    # Subscribe to topic
    topic = "images"
    consumer.subscribe([topic])

    # Poll for new messages from Kafka and print them.
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
            filename = os.path.join("imgs_folder", f"image_{count}.jpg")
            # filename=(r"imgs_folder\image_{count}.jpg")
            # Save the image to a file
            save_image(decoded_image, filename)  # Save image as received_image.jpg
            print("Image received and saved successfully.")
            count=count+1

    except KeyboardInterrupt:
        pass
    finally:
        # Leave group and commit final offsets
        consumer.close()
if __name__ == '__main__':
    # clear_folder("imgs_folder")
    main()