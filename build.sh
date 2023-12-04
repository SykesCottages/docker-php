#!/bin/bash

VERSION=$1
ARCH=$2

TAG_CLI="sykescottages/php:${VERSION}-cli-${ARCH}"
TAG_FPM="sykescottages/php:${VERSION}-fpm-${ARCH}"

docker build --quiet --no-cache -t $TAG_CLI --build-arg ARCH=$ARCH $VERSION/cli
docker push $TAG_CLI

docker build --quiet --no-cache -t $TAG_FPM --build-arg ARCH=$ARCH $VERSION/fpm
docker push $TAG_FPM
