#!/bin/sh

docker-compose -f base/docker-compose.test.yml build --no-cache && \
    docker-compose -f base/docker-compose.test.yml up

docker-compose -f 5.6/cli/docker-compose.test.yml build --no-cache && \
    docker-compose -f 5.6/cli/docker-compose.test.yml up

docker-compose -f 7.0/cli/docker-compose.test.yml build --no-cache && \
    docker-compose -f 7.0/cli/docker-compose.test.yml up

docker-compose -f 7.1/cli/docker-compose.test.yml build --no-cache && \
    docker-compose -f 7.1/cli/docker-compose.test.yml up

docker-compose -f 7.2/cli/docker-compose.test.yml build --no-cache && \
    docker-compose -f 7.2/cli/docker-compose.test.yml up

docker-compose -f 7.3/cli/docker-compose.test.yml build --no-cache && \
    docker-compose -f 7.3/cli/docker-compose.test.yml up

docker-compose -f 7.4/cli/docker-compose.test.yml build --no-cache && \
    docker-compose -f 7.4/cli/docker-compose.test.yml up