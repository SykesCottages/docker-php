FROM sykescottages/php:base

RUN apt-get update && \
    apt-get install -y -q \
        php7.0 \
        php7.0-bcmath \
        php7.0-curl \
        php7.0-dev \
        php7.0-intl \
        php7.0-json \
        php7.0-mbstring \
        php7.0-mysql \
        php7.0-soap \
        php7.0-xml \
        php7.0-zip

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "entrypoint-cli" ]
