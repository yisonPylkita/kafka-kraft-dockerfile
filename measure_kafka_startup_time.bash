#!/usr/bin/env bash

START_TIMESTAMP=$(python3 time.py)
#docker run -p 9092:9092 -p 9093:9093 --mount source=kafka_logs,destination=/tmp/kraft-combined-logs -d -it kafka-kraft
docker run -p 9092:9092 -p 9093:9093 -d -it kafka-kraft
sleep 2

until $(kcat -L -b localhost:9092 -t object-models &>/dev/null); do
    echo "Could't connect to Kafka"
done
END_TIMESTAMP=$(python3 time.py)

echo "Kafka start with usable topic took"
echo $((($END_TIMESTAMP - $START_TIMESTAMP)))
echo "miliseconds"

docker ps | awk {' print $1 '} | tail -n+2 >tmp.txt
for line in $(cat tmp.txt); do docker stop $line; done
rm tmp.txt
