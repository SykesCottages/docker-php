#!/bin/bash

VERSIONS=($(find . -type d -regex '.*/[0-9]+\.[0-9]' | sort | sed 's/\.\///'))

for VERSION in "${VERSIONS[@]}"
do
  docker run sykescottages/php:${VERSION}-cli -v|grep -E "^PHP "
done
