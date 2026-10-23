ARG ARCH=amd64
FROM sykescottages/php:8-base-$ARCH

RUN apt-get update -y; \
    apt-get install -y -q \
        php8.5 \
        php8.5-decimal \
        php8.5-bcmath \
        php8.5-curl \
        php8.5-dev \
        php8.5-intl \
        php8.5-mbstring \
        php8.5-mysql \
        php8.5-soap \
        php8.5-xml \
        php8.5-zip \
        php8.5-protobuf \
        php8.5-opentelemetry

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

RUN phpdismod opentelemetry && \
    phpdismod protobuf

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/8.5/cli/php.ini

# Disable session upload progress
RUN echo "session.upload_progress.enabled = 0" >> /etc/php/8.5/cli/php.ini

ENTRYPOINT [ "entrypoint-cli" ]