#!/bin/bash

VERSIONS=( "5.6" "7.0" "7.1" "7.2" "7.3" "7.4" "8.0" "8.1" "8.2" )
for VERSION in "${VERSIONS[@]}"
do
  docker run sykescottages/php:${VERSION}-cli -v|grep -E "^PHP "
done
