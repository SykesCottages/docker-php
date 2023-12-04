FROM --platform=$BUILDPLATFORM sykescottages/php:8-base

RUN apt-get update; \
    apt-get install -y -q \
        php8.2 \
        php8.2-bcmath \
        php8.2-curl \
        php8.2-dev \
        php8.2-intl \
        php8.2-mbstring \
        php8.2-mysql \
        php8.2-soap \
        php8.2-xml \
        php8.2-zip

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/8.2/cli/php.ini

ENTRYPOINT [ "entrypoint-cli" ]