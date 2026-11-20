#!/bin/bash
set -euo pipefail

export DOCKER_CLI_EXPERIMENTAL=enabled
DATE=$(date '+%Y%m%d')

docker login >>/dev/null 2>&1

# Update the base alpine manifests
BASE_VERSIONS=($(find . -maxdepth 1 -type d | grep -E '^\./[0-9]+-base' | sort | sed 's/\.\///'))

for VERSION in "${BASE_VERSIONS[@]}"
do
  TAG="sykescottages/php:$VERSION"
  docker manifest rm "$TAG" || true
  docker manifest create "$TAG" \
    --amend "$TAG-amd64" \
    --amend "$TAG-arm64"
  docker manifest push "$TAG"
done

# Update the PHP specific versions manifests
VERSIONS=($(find . -maxdepth 1 -type d | grep -E '^\./[0-9]+\.[0-9]+$' | sort | sed 's/\.\///'))
while IFS= read -r SRC_VERSION; do
  [ -n "$SRC_VERSION" ] && VERSIONS+=("${SRC_VERSION}-src")
done < src/versions
for VERSION in "${VERSIONS[@]}"
do
  TAG="sykescottages/php:${VERSION}-cli"
  docker manifest rm "$TAG" || true
  docker manifest create "$TAG" \
    --amend "$TAG-amd64" \
    --amend "$TAG-arm64"
  docker manifest push "$TAG"

  VERSION_TAG="${TAG}-${DATE}"
  docker manifest rm "$VERSION_TAG" || true
  docker manifest create "$VERSION_TAG" \
    --amend "$TAG-amd64" \
    --amend "$TAG-arm64"
  docker manifest push "$VERSION_TAG"

  TAG="sykescottages/php:${VERSION}-fpm"
  docker manifest rm "$TAG" || true
  docker manifest create "$TAG" \
    --amend "$TAG-amd64" \
    --amend "$TAG-arm64"
  docker manifest push "$TAG"

  VERSION_TAG="${TAG}-${DATE}"
  docker manifest rm "$VERSION_TAG" || true
  docker manifest create "$VERSION_TAG" \
    --amend "$TAG-amd64" \
    --amend "$TAG-arm64"
  docker manifest push "$VERSION_TAG"

done
