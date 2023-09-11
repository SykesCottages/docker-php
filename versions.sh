#!/bin/bash

VERSIONS=($(find . -type d -regex '.*/[0-9]\{1,2\}\.[0-9]' | sort))

for VERSION in "${VERSIONS[@]}"
do
  docker run sykescottages/php:${VERSION}-cli -v|grep -E "^PHP "
done
