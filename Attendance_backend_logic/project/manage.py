from confluent_kafka.admin import AdminClient, NewTopic, TopicDescription
from confluent_kafka import TopicCollection
import time

# Function to check for existing topics
def check_topics(admin_client):
    topics_metadata = admin_client.list_topics(timeout=10)
    return topics_metadata.topics

# Function to create topics
def create_topic(admin_client, topic_name, num_partitions, replication_factor):
    topic = NewTopic(topic_name, num_partitions, replication_factor)
    admin_client.create_topics([topic])

# Function to delete topics
def delete_topic(admin_client, topic_name):
    admin_client.delete_topics([topic_name])

# Function to show topic details
def topic_detail(admin_client, topic_list):
    topic_collection = TopicCollection(topic_list)
    topic_describe = admin_client.describe_topics(topic_collection)
    for index, topic_name in enumerate(topic_list):
        topic_description = topic_describe[topic_name].result()
        print(f"Topic {index+1}: ")
        print(topic_description.name)
        print(topic_description.topic_id)
        print(topic_description.is_internal)
        print(topic_description.partitions[0].id)

def perform_operation(operation, admin_client):
    if operation == 0:
        return
    else:
        if operation == 1 or operation == 2 or operation == 4:
            topic_num = int(input("Number of topics: "))
            topic_list = []
            for n in range(topic_num):
                topic = input(f"Topic name {n+1}: ")
                topic_list.append(topic)
            print()
            if operation == 1:
                num_partitions = int(input("Number of partitions: "))
                replication_factor = int(input("Number of replication factors: "))
                existing_topics = check_topics(admin_client)
                for topic_name in topic_list:
                    if topic_name not in existing_topics:
                        print(f"Creating topic: {topic_name}")
                        create_topic(admin_client, topic_name, num_partitions, replication_factor)
                        # Wait for topic creation
                        time.sleep(3)
                        print(f"Created topic: {topic_name}")
                    else:
                        print(f"Topic {topic_name} already exists")
            elif operation == 2:
                for topic_name in topic_list:
                    print(f"Deleting topic: {topic_name}")
                    delete_topic(admin_client, topic_name)
                    print(f"Deleted topic: {topic_name}")
            elif operation == 4:
                topic_detail(admin_client, topic_list)
        else:
            existing_topics = check_topics(admin_client)
            print("Existing topics: ", existing_topics)


if __name__ == "__main__":
    # Kafka broker
    bootstrap_servers = '192.168.120.46:9092'
    admin_client = AdminClient({'bootstrap.servers': bootstrap_servers})

    while True: 
        operation = int(input("Choose operation (Create - 1|Delete - 2|List - 3|Detail - 4|Exit - 0): "))
        print()
        if operation == 0:
            break
        else:
            perform_operation(operation, admin_client)
        print()
