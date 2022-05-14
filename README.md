# kafka-kraft-dockerfile
Dockerfile of Kafka in KRaft mode (without Zookeeper)

## Usage

```bash
# First run
docker container prune -f
#docker volume rm -f kafka_logs

docker build -t kafka-kraft .
docker volume create kafka_logs
# docker run -p 9092:9092 -p 9093:9093 -e KAFKA_CREATE_TOPIC='object-models,timeseries' -e KAFKA_FIRST_TIME_SETUP=1 --mount source=kafka_logs,destination=/tmp/kraft-combined-logs -it kafka-kraft
docker run -p 9092:9092 -p 9093:9093 -e KAFKA_CREATE_TOPIC='object-models,timeseries' -e KAFKA_FIRST_TIME_SETUP=1 -it kafka-kraft
kcat -L -b localhost:9092

kcat -b localhost:9092 -t object-models -T -P -l test-data
kcat -b localhost:9092 -t object-models -C

# Later runs
docker run -p 9092:9092 -p 9093:9093 --mount source=kafka_logs,destination=/tmp/kraft-combined-logs  -d -it kafka-kraft
kcat -L -b localhost:9092
```

## Missing features
- Passing Kafka config as ENVs
- Replication and scaling
