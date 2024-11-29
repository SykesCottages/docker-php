#!/bin/bash

export DOCKER_CLI_EXPERIMENTAL=enabled
DATE=$(date '+%Y%m%d')

docker login >>/dev/null 2>&1

BASE_VERSIONS=($(find . -type d -regex '\.*/[0-9]+-base' | sort | sed 's/\.\///'))
for VERSION in "${BASE_VERSIONS[@]}"
do
  TAG="sykescottages/php:$VERSION"
  docker manifest rm $TAG
  docker manifest create $TAG \
    --amend "$TAG-amd64" \
    --amend "$TAG-arm64"
  docker manifest push $TAG
done

VERSIONS=($(find . -type d -regex '\.*/[0-9]+\.[0-9]+' | sort | sed 's/\.\///'))
for VERSION in "${VERSIONS[@]}"
do
  TAG="sykescottages/php:${VERSION}-cli"
  docker manifest rm $TAG
  docker manifest create $TAG \
    --amend "$TAG-amd64" \
    --amend "$TAG-arm64"
  docker manifest push $TAG

  VERSION_TAG="${TAG}-${DATE}"
  docker manifest rm $VERSION_TAG
  docker manifest create $VERSION_TAG \
    --amend "$TAG-amd64" \
    --amend "$TAG-arm64"
  docker manifest push $VERSION_TAG

  TAG="sykescottages/php:${VERSION}-fpm"
  docker manifest rm $TAG
  docker manifest create $TAG \
    --amend "$TAG-amd64" \
    --amend "$TAG-arm64"
  docker manifest push $TAG

  VERSION_TAG="${TAG}-${DATE}"
  docker manifest rm $VERSION_TAG
  docker manifest create $VERSION_TAG \
    --amend "$TAG-amd64" \
    --amend "$TAG-arm64"
  docker manifest push $VERSION_TAG

done
