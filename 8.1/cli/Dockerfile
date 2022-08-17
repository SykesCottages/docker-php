FROM sykescottages/php:base

COPY --from=composer /usr/bin/composer /usr/bin/composer

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

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/8.1/cli/php.ini

ENTRYPOINT [ "entrypoint-cli" ]