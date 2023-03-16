#!/bin/bash

# You need to provide your own creds because #security
docker login

VERSIONS=( "5-base" "7-base" "8-base" )
for VERSION in "${VERSIONS[@]}"
do
  docker build --no-cache -t sykescottages/php:${VERSION} ${VERSION}
  docker push sykescottages/php:${VERSION}
done

VERSIONS=( "5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.0" "8.1" "8.2" )
for VERSION in "${VERSIONS[@]}"
do
  docker build --no-cache -t sykescottages/php:${VERSION}-cli $VERSION/cli
  docker push sykescottages/php:${VERSION}-cli

  docker build --no-cache -t sykescottages/php:${VERSION}-fpm $VERSION/fpm
  docker push sykescottages/php:${VERSION}-fpm

  docker rmi sykescottages/php:${VERSION}-cli
  docker rmi sykescottages/php:${VERSION}-fpm
done

VERSIONS=( "5-base" "7-base" "8-base" )
for VERSION in "${VERSIONS[@]}"
do
  docker rmi sykescottages/php:${VERSION}
done
