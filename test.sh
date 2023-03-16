#!/bin/bash

VERSIONS=("5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.0" "8.1")
for VERSION in "${VERSIONS[@]}"; do
  docker-compose -f $VERSION/cli/docker-compose.test.yml build --no-cache &&
    docker-compose -f $VERSION/cli/docker-compose.test.yml run --rm sut

  if [ $? -eq 0 ]; then
    echo "$VERSION Image Test Passed"
  else
    echo "$VERSION Image Test Failed"
    exit
  fi

  docker-compose -f $VERSION/cli/docker-compose.test.yml down
done
