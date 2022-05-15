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
