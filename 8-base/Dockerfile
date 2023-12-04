FROM --platform=$BUILDPLATFORM sykescottages/base:ubuntu-22-04

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime 

RUN add-apt-repository ppa:ondrej/php

COPY entrypoint-cli /usr/local/bin/
COPY entrypoint-fpm /usr/local/bin/

COPY --from=composer /usr/bin/composer /usr/bin/composer
