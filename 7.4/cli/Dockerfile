ARG ARCH=amd64
FROM sykescottages/php:7-base-$ARCH

RUN apt-get update; \
    apt-get install -y -q \
        php7.4 \
        php7.4-decimal \
        php7.4-bcmath \
        php7.4-curl \
        php7.4-dev \
        php7.4-intl \
        php7.4-json \
        php7.4-mbstring \
        php7.4-mysql \
        php7.4-soap \
        php7.4-xml \
        php7.4-zip \
        php7.4-uopz

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/7.4/cli/php.ini

# Disable session upload progress
RUN echo "session.upload_progress.enabled = Off" >> /etc/php/7.4/cli/php.ini
RUN echo "uopz.exit = 1" >> /etc/php/7.4/mods-available/uopz.ini

COPY ./test.php /tmp/test.php
COPY ./run_tests.sh /tmp/test.sh

RUN chmod +x /tmp/test.sh && /tmp/test.sh

ENTRYPOINT [ "entrypoint-cli" ]
