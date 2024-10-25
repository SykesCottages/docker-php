ARG ARCH=amd64
FROM sykescottages/php:8-base-$ARCH

RUN apt-get update; \
    apt-get install -y -q \
        php8.4 \
        php8.4-bcmath \
        php8.4-curl \
        php8.4-dev \
        php8.4-intl \
        php8.4-mbstring \
        php8.4-mysql \
        php8.4-soap \
        php8.4-xml \
        php8.4-zip

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/8.4/cli/php.ini

ENTRYPOINT [ "entrypoint-cli" ]