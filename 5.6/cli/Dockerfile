ARG ARCH=amd64
FROM sykescottages/php:5-base-$ARCH

RUN apt-get update && \
    apt-get install -y -q \
        php5.6 \
        php5.6-bcmath \
        php5.6-curl \
        php5.6-dev \
        php5.6-intl \
        php5.6-json \
        php5.6-mbstring \
        php5.6-mysql \
        php5.6-soap \
        php5.6-xml \
        php5.6-zip

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/5.6/cli/php.ini

ENTRYPOINT [ "entrypoint-cli" ]
