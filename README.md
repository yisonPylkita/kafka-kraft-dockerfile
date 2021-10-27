# kafka-kraft-dockerfile
Dockerfile of Kafka in KRaft mode (without Zookeeper)

## Usage

```bash
docker build -t kafka-kraft .
docker run -it kafka-kraft
```

## Missing features
- Passing Kafka config as ENVs
- Ability to start Kafka with specified partitions
- Replication and scaling

