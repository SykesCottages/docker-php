#!/bin/bash

VERSION=$1

docker build --no-cache -t sykescottages/php:${VERSION} ${VERSION}
docker push sykescottages/php:${VERSION}