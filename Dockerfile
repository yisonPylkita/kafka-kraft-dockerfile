FROM debian:stable-slim

COPY start_kafka.bash /bin/
COPY start_kafka_with_first_time_setup.bash /bin/

RUN apt update && apt install wget default-jre vim -y
RUN wget https://dlcdn.apache.org/kafka/3.2.0/kafka_2.13-3.2.0.tgz && \
    tar xvf kafka_2.13-3.2.0.tgz -C /opt && \
    mv /opt/kafka_2.13-3.2.0 /opt/kafka

WORKDIR /opt/kafka
CMD ["/bin/start_kafka.bash"]
# CMD ["/bin/start_kafka_with_first_time_setup.bash"]
