#!/bin/bash

# Validate the container passes our tests
#./test.sh

# You need to provide your own creds because #security
docker login

VERSIONS=( "5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.0" )
for VERSION in "${VERSIONS[@]}"
do
  docker build --no-cache -t sykescottages/php:${VERSION}-fpm $VERSION/fpm
  docker push sykescottages/php:${VERSION}-fpm

  docker build --no-cache -t sykescottages/php:${VERSION}-cli $VERSION/cli
  docker push sykescottages/php:${VERSION}-cli
done
