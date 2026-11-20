#!/bin/bash
set -euo pipefail

VERSION=$1
ARCH=$2

TAG_CLI="sykescottages/php:${VERSION}-cli-${ARCH}"
TAG_FPM="sykescottages/php:${VERSION}-fpm-${ARCH}"

if [[ "$VERSION" == *-src ]]; then
  PHP_VERSION="${VERSION%-src}"
  docker build --quiet --no-cache -t "$TAG_CLI" --build-arg ARCH="$ARCH" --build-arg PHP_VERSION="$PHP_VERSION" src/cli
  docker push "$TAG_CLI"

  docker build --quiet --no-cache -t "$TAG_FPM" --build-arg ARCH="$ARCH" --build-arg PHP_VERSION="$PHP_VERSION" src/fpm
  docker push "$TAG_FPM"
else
  docker build --quiet --no-cache -t "$TAG_CLI" --build-arg ARCH="$ARCH" "$VERSION/cli"
  docker push "$TAG_CLI"

  docker build --quiet --no-cache -t "$TAG_FPM" --build-arg ARCH="$ARCH" "$VERSION/fpm"
  docker push "$TAG_FPM"
fi
