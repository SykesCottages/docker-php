#!/bin/bash

VERSIONS=($(find . -maxdepth 1 -type d | grep -E '^\./[0-9]+\.[0-9]+$' | sort | sed 's/\.\///'))
for VERSION in "${VERSIONS[@]}"
do
  docker-compose -f $VERSION/cli/docker-compose.test.yml build --no-cache &&
    docker-compose -f $VERSION/cli/docker-compose.test.yml run --rm sut

  if [ $? -eq 0 ]; then
    echo "$VERSION Image Test Passed"
  else
    echo "$VERSION Image Test Failed"
    exit 1
  fi

  docker-compose -f $VERSION/cli/docker-compose.test.yml down
done

while IFS= read -r SRC_VERSION; do
  [ -n "$SRC_VERSION" ] || continue
  PHP_VERSION="$SRC_VERSION" docker-compose -f src/cli/docker-compose.test.yml build --no-cache &&
    PHP_VERSION="$SRC_VERSION" docker-compose -f src/cli/docker-compose.test.yml run --rm sut

  if [ $? -eq 0 ]; then
    echo "${SRC_VERSION}-src Image Test Passed"
  else
    echo "${SRC_VERSION}-src Image Test Failed"
    exit 1
  fi

  PHP_VERSION="$SRC_VERSION" docker-compose -f src/cli/docker-compose.test.yml down
done < src/versions
