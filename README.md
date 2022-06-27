# kafka-kraft-dockerfile
Dockerfile of Kafka in KRaft mode (without Zookeeper)

## Usage

```bash
# In case you want to start anew
docker container prune -f
docker volume rm -f kafka_logs

# Build and run Kafka Kraft
docker build -t kafka-kraft .
docker volume create kafka_logs
docker run -p 9092:9092 -p 9093:9093 -e KAFKA_CREATE_TOPICS='object-models,timeseries,calculations,functions' --mount source=kafka_logs,destination=/tmp/kraft-combined-logs -it kafka-kraft

# Check if topics exist
kcat -L -b localhost:9092
```

## Missing features
- Passing Kafka config as ENVs
- Replication and scaling




## Random commands
```bash
 docker run \
-e KAFKA_LISTENERS="PLAINTEXT://:9091,INTERNAL://:9092,EXTERNAL://:9093,NODEPORT://:30092,CONTROLLER://:9094" \
-e KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://:localhost:9091,INTERNAL://localhost:9092,EXTERNAL://kafka-serv:9093,NODEPORT://localhost:30092" \
-e KAFKA_CONTROLLER_LISTENER="CONTROLLER" \
-e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP="PLAINTEXT:PLAINTEXT,INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT,NODEPORT:PLAINTEXT,CONTROLLER:PLAINTEXT" \
-e KAFKA_CREATE_TOPICS="object-models,timeseries,calculations,functions" \
-it kafka-kraft /bin/bash /bin/start_kafka.bash


docker run -P \
-e KAFKA_LISTENERS="PLAINTEXT://:9092,CONTROLLER://:9093" \
-e KAFKA_ADVERTISED_LISTENERS="PLAINTEXT://:9092" \
-e KAFKA_CONTROLLER_LISTENER="CONTROLLER" \
-e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP="CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL" \
-e KAFKA_CREATE_TOPICS="object-models,timeseries,calculations,functions" \
-it kafka-kraft /bin/bash /bin/start_kafka.bash
```