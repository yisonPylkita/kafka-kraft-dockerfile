#!/usr/bin/env bash

# Bash job control (fg, bg)
set -m

# Setup storage for Kafka
CLUSTER_ID=$(/opt/kafka/bin/kafka-storage.sh random-uuid)
/opt/kafka/bin/kafka-storage.sh format -t $CLUSTER_ID -c /opt/kafka/config/kraft/server.properties

echo "Starting Kafka"
# First one runs in background
/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties &

# Second one will create topics and close. Then return first one to foreground for SIGINT|SIGTERM
export IFS=","
for TOPIC in $KAFKA_CREATE_TOPICS; do
    until echo "Trying to create topic $TOPIC" && /opt/kafka/bin/kafka-topics.sh --create --topic $TOPIC --partitions 1 --replication-factor 1 --bootstrap-server localhost:9092; do
        echo "Failed to create topic $TOPIC. Retry"
    done
done
fg
