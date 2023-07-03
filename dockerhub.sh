#!/bin/bash

# You need to provide your own creds because #security
docker login >> /dev/null 2>&1

VERSIONS=( "5-base" "7-base" "8-base" )
for VERSION in "${VERSIONS[@]}"
do
  ./build-base.sh $VERSION >> /dev/null 2>&1 &
done

wait

VERSIONS=( "5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.0" "8.1" "8.2" )
for VERSION in "${VERSIONS[@]}"
do
  ./build.sh $VERSION >> /dev/null 2>&1 &
done

wait

VERSIONS=( "5-base" "7-base" "8-base" )
for VERSION in "${VERSIONS[@]}"
do
  docker rmi sykescottages/php:${VERSION} >> /dev/null 2>&1 &
done

wait
