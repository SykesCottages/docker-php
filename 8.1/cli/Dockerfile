FROM sykescottages/php:base

RUN apt-get update; \
    apt-get install -y -q \
        php8.1 \
        php8.1-bcmath \
        php8.1-curl \
        php8.1-dev \
        php8.1-intl \
        php8.1-mbstring \
        php8.1-mysql \
        php8.1-soap \
        php8.1-xml \
        php8.1-zip

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "entrypoint-cli" ]