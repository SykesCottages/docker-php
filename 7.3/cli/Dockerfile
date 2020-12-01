FROM sykescottages/php:base

RUN apt-get update && \
    apt-get install -y -q \
        php7.3 \
        php7.3-bcmath \
        php7.3-curl \
        php7.3-dev \
        php7.3-intl \
        php7.3-json \
        php7.3-mbstring \
        php7.3-mysql \
        php7.3-soap \
        php7.3-xml \
        php7.3-zip

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "entrypoint-cli" ]
