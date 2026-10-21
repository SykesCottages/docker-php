ARG ARCH=amd64
FROM sykescottages/php:8-base-$ARCH

RUN apt-get update; \
    apt-get install -y -q \
        php8.3 \
        php8.3-decimal \
        php8.3-bcmath \
        php8.3-curl \
        php8.3-dev \
        php8.3-intl \
        php8.3-mbstring \
        php8.3-mysql \
        php8.3-soap \
        php8.3-xml \
        php8.3-zip \
        php8.3-protobuf \
        php8.3-opentelemetry

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

RUN phpdismod opentelemetry && \
    phpdismod protobuf

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/8.3/cli/php.ini

# Disable session upload progress
RUN echo "session.upload_progress.enabled = Off" >> /etc/php/8.3/cli/php.ini

ENTRYPOINT [ "entrypoint-cli" ]