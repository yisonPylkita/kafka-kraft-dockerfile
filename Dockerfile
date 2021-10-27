FROM debian:stable-slim

RUN apt update
RUN apt install wget default-jre -y

RUN wget https://dlcdn.apache.org/kafka/3.0.0/kafka_2.12-3.0.0.tgz && \
    tar xvf kafka_2.12-3.0.0.tgz

WORKDIR kafka_2.12-3.0.0
# TODO: ID is static. Change it to one generated at startup
RUN ./bin/kafka-storage.sh format -t DLwcm1QBR76k2ONUa4VwYw -c ./config/kraft/server.properties
CMD ./bin/kafka-server-start.sh ./config/kraft/server.properties
