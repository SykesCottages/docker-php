#!/bin/bash

VERSIONS=($(find . -type d -regex '\.*/[0-9]+\.[0-9]+' | sort | sed 's/\.\///'))

for VERSION in "${VERSIONS[@]}"
do
  docker run --pull always -it sykescottages/php:${VERSION}-fpm bash -c "apt -qq list | tail -n+2" | tail -n+4 > $VERSION/fpm/aptitude-itinerary
  docker run --pull always -it sykescottages/php:${VERSION}-cli bash -c "apt -qq list | tail -n+2" | tail -n+4 > $VERSION/cli/aptitude-itinerary
done

for VERSION in "${VERSIONS[@]}"
do
  docker run --pull always sykescottages/php:${VERSION}-cli -v|grep -E "^PHP "
done
