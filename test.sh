#!/bin/bash

VERSIONS=($(find . -type d -regex '.*/[0-9]\{1,2,\}\.[0-9]' | sort))

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
