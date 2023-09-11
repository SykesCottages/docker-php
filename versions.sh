#!/bin/bash

VERSIONS=($(find . -type d -name '[0-9]\.[0-9]' | sort))

for VERSION in "${VERSIONS[@]}"
do
  docker run sykescottages/php:${VERSION}-cli -v|grep -E "^PHP "
done
