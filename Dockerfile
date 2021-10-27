FROM debian:stable-slim

RUN apt update
RUN apt install wget default-jre -y

RUN wget https://dlcdn.apache.org/kafka/3.0.0/kafka_2.12-3.0.0.tgz && \
    tar xvf kafka_2.12-3.0.0.tgz

WORKDIR kafka_2.12-3.0.0
RUN CLUSTER_ID=$(./bin/kafka-storage.sh random-uuid) && ./bin/kafka-storage.sh format -t $CLUSTER_ID -c ./config/kraft/server.properties
CMD ./bin/kafka-server-start.sh -daemon ./config/kraft/server.properties && \
    ./bin/kafka-topics.sh --create --topic $KAFKA_CREATE_TOPIC --partitions 1 --replication-factor 1 --bootstrap-server localhost:9092 && \
    sleep 999999999999

