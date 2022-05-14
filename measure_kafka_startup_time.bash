#!/usr/bin/env bash

START_TIMESTAMP=$(date +%s)
docker run \
    -p 9092:9092 -p 9093:9093 \
    -e KAFKA_CREATE_TOPIC='object-models,timeseries' \
    -e KAFKA_FIRST_TIME_SETUP=1 \
    -d -it kafka-kraft &>/dev/null

until $(kcat -L -b localhost:9092 -t object-models &>/dev/null); do
    echo "Could't connect to Kafka"
done
END_TIMESTAMP=$(date +%s)

echo "Kafka start with usable topic took"
echo $((($END_TIMESTAMP - $START_TIMESTAMP)))
echo "seconds"

# Remove all containers
docker ps | awk {' print $1 '} | tail -n+2 >tmp.txt
for line in $(cat tmp.txt); do docker kill $line >/dev/null; done
rm tmp.txt
