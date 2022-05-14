#!/usr/bin/env bash

# Bash job control (fg, bg)
set -m

if [[ -d /tmp/kraft-combined-logs ]]; then
    KAFKA_FIRST_TIME_SETUP=1
    CLUSTER_ID=$(/opt/kafka/bin/kafka-storage.sh random-uuid)
    /opt/kafka/bin/kafka-storage.sh format -t $CLUSTER_ID -c /opt/kafka/config/kraft/server.properties
fi

echo "Starting Kafka"
if [[ -z "$KAFKA_FIRST_TIME_SETUP" ]]; then
    /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties
else
    # First one runs in background
    /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties &

    # Second one will create topics and close. Then return first one to foreground for SIGINT|SIGTERM
    export IFS=","
    for TOPIC in $KAFKA_CREATE_TOPIC; do
        until /opt/kafka/bin/kafka-topics.sh --create --topic $TOPIC --partitions 1 --replication-factor 1 --bootstrap-server localhost:9092; do
            echo "Failed to create topic $TOPIC. Retry"
        done
    done
    fg
fi
