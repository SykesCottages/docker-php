ARG ARCH=amd64
FROM sykescottages/php:8-base-$ARCH

RUN apt-get update; \
    apt-get install -y -q \
        php8.0 \
        php8.0-bcmath \
        php8.0-curl \
        php8.0-dev \
        php8.0-intl \
        php8.0-mbstring \
        php8.0-mysql \
        php8.0-soap \
        php8.0-xml \
        php8.0-zip

RUN update-alternatives --set php /usr/bin/php8.0

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/8.0/cli/php.ini

ENTRYPOINT [ "entrypoint-cli" ]