#!/bin/bash

# You need to provide your own creds because #security
docker login >> /dev/null 2>&1

BASE_VERSIONS=($(find . -type d -regex '.*/[0-9]\{1,2\}-base' | sort | sed 's/\.\///'))
for VERSION in "${BASE_VERSIONS[@]}"
do
  ./build-base.sh $VERSION >> /dev/null 2>&1 &
done

wait

VERSIONS=($(find . -type d -regex '.*/[0-9]\{1,2\}\.[0-9]' | sort))
for VERSION in "${VERSIONS[@]}"
do
  ./build.sh $VERSION >> /dev/null 2>&1 &
done

wait

for VERSION in "${BASE_VERSIONS[@]}"
do
  docker rmi sykescottages/php:${VERSION} >> /dev/null 2>&1 &
done

wait
