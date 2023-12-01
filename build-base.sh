#!/bin/bash

VERSION=$1

docker build --no-cache -t sykescottages/php:${VERSION} ${VERSION}
docker push sykescottages/php:${VERSION}

docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm64/v8 \
  --quiet \
  --no-cache \
  --push \
  -t sykescottages/php:${VERSION} \
  $VERSION