#!/bin/bash

docker-compose -f base/docker-compose.test.yml build --no-cache && \
    docker-compose -f base/docker-compose.test.yml run --rm sut

VERSIONS=( "5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.0" )
for VERSION in "${VERSIONS[@]}"
do
  docker-compose -f $VERSION/cli/docker-compose.test.yml build --no-cache && \
    docker-compose -f $VERSION/cli/docker-compose.test.yml run --rm sut
done
