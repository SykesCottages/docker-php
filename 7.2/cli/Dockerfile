ARG ARCH=amd64
FROM sykescottages/php:7-base-$ARCH

RUN apt-get update && \
    apt-get install -y -q \
        php7.2 \
        php7.2-bcmath \
        php7.2-curl \
        php7.2-dev \
        php7.2-intl \
        php7.2-json \
        php7.2-mbstring \
        php7.2-mysql \
        php7.2-soap \
        php7.2-xml \
        php7.2-zip

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/7.2/cli/php.ini

ENTRYPOINT [ "entrypoint-cli" ]
