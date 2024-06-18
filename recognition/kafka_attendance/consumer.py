from argparse import ArgumentParser, FileType
from configparser import ConfigParser
from confluent_kafka import Consumer, OFFSET_BEGINNING

if __name__ == '__main__':
    kafka_config = {
        'bootstrap.servers': '172.20.10.2:9092',
        'group.id': '1',
        'auto.offset.reset': 'earliest'
    }

    # Create Consumer instance
    consumer = Consumer(kafka_config)

    # Set up a callback to handle the '--reset' flag.
    def reset_offset(consumer, partitions):
        # if args.reset:
        #     for p in partitions:
        #         p.offset = OFFSET_BEGINNING
        #     consumer.assign(partitions)
        return

    # Subscribe to topic
    topic = "messages"
    consumer.subscribe([topic], on_assign=reset_offset)

    # Poll for new messages from Kafka and print them.
    try:
        while True:
            msg = consumer.poll(1.0)
            if msg is None:
                # Initial message consumption may take up to
                # `session.timeout.ms` for the consumer group to
                # rebalance and start consuming
                print("Waiting...")
            elif msg.error():
                print("ERROR: %s".format(msg.error()))
            else:
                # Extract the (optional) key and value, and print.

                print("Consumed event from topic {topic}: key = {key:12} value = {value:12}".format(
                    topic=msg.topic(), key=msg.key().decode('utf-8'), value=msg.value().decode('utf-8')))
    except KeyboardInterrupt:
        pass
    finally:
        # Leave group and commit final offsets
        consumer.close()