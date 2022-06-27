#!/usr/bin/env bash

# Bash job control (fg, bg)
set -m

# Setup storage for Kafka
CLUSTER_ID=$(/opt/kafka/bin/kafka-storage.sh random-uuid)
/opt/kafka/bin/kafka-storage.sh format -t $CLUSTER_ID -c /opt/kafka/config/kraft/server.properties

# Set Kafka options
echo "listeners=$KAFKA_LISTENERS" >> /opt/kafka/config/kraft/server.properties
echo "advertised.listeners=$KAFKA_ADVERTISED_LISTENERS" >> /opt/kafka/config/kraft/server.properties
echo "listener.security.protocol.map=$KAFKA_LISTENER_SECURITY_PROTOCOL_MAP" >> /opt/kafka/config/kraft/server.properties
echo "controller.listener.names=$KAFKA_CONTROLLER_LISTENER" >> /opt/kafka/config/kraft/server.properties
echo "inter.broker.listener.name=$KAFKA_INTER_BROKER_LISTENER_NAME" >> /opt/kafka/config/kraft/server.properties
echo "controller.quorum.voters=$KAFKA_CONTROLLER_QUORUM_VOTERS" >> /opt/kafka/config/kraft/server.properties


echo "Kafka configuration" # without comments and newlines
echo ""
grep -v "^#" /opt/kafka/config/kraft/server.properties | grep -v "^$"
echo ""

echo "Starting Kafka"
# First one runs in background
/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties &

# Second one will create topics in background
IFS=,
for TOPIC_INFO in $KAFKA_CREATE_TOPICS
do
    IFS=: read -r TOPIC PARTITIONS REPLICAS <<< $TOPIC_INFO
    echo "Creating topic '$TOPIC' with '$PARTITIONS' partitions and '$REPLICAS' replicas" && \
    /opt/kafka/bin/kafka-topics.sh \
    --create \
    --topic $TOPIC \
    --partitions $PARTITIONS \
    --replication-factor $REPLICAS \
    --bootstrap-server $KAFKA_BOOTSTRAP_SERVER &
done

# Get first one back to foreground to handle SIGTERM and SIGINT
fg %/opt/kafka/bin/kafka-server-start.sh
