FROM sykescottages/php:7-base

RUN apt-get update; \
    apt-get install -y -q \
        php7.4 \
        php7.4-bcmath \
        php7.4-curl \
        php7.4-dev \
        php7.4-intl \
        php7.4-json \
        php7.4-mbstring \
        php7.4-mysql \
        php7.4-soap \
        php7.4-xml \
        php7.4-zip

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/7.4/cli/php.ini

ENTRYPOINT [ "entrypoint-cli" ]
