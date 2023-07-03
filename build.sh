#!/bin/bash

VERSION=$1

docker build --no-cache -t sykescottages/php:${VERSION}-cli $VERSION/cli
docker push sykescottages/php:${VERSION}-cli

docker build --no-cache -t sykescottages/php:${VERSION}-fpm $VERSION/fpm
docker push sykescottages/php:${VERSION}-fpm

docker rmi sykescottages/php:${VERSION}-cli
docker rmi sykescottages/php:${VERSION}-fpm