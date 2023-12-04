FROM --platform=$BUILDPLATFORM sykescottages/php:8-base

RUN apt-get update; \
    apt-get install -y -q \
        php8.3 \
        php8.3-bcmath \
        php8.3-curl \
        php8.3-dev \
        php8.3-intl \
        php8.3-mbstring \
        php8.3-mysql \
        php8.3-soap \
        php8.3-xml \
        php8.3-zip

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/8.3/cli/php.ini

ENTRYPOINT [ "entrypoint-cli" ]