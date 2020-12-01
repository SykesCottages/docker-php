FROM sykescottages/php:base

RUN apt-get update && \
    apt-get install -y -q \
        php7.1 \
        php7.1-bcmath \
        php7.1-curl \
        php7.1-dev \
        php7.1-intl \
        php7.1-json \
        php7.1-mbstring \
        php7.1-mysql \
        php7.1-soap \
        php7.1-xml \
        php7.1-zip

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "entrypoint-cli" ]