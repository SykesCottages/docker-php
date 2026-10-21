ARG ARCH=amd64
FROM sykescottages/php:7-base-$ARCH

RUN apt-get update && \
    apt-get install -y -q \
        php7.3 \
        php7.3-decimal \
        php7.3-bcmath \
        php7.3-curl \
        php7.3-dev \
        php7.3-intl \
        php7.3-json \
        php7.3-mbstring \
        php7.3-mysql \
        php7.3-soap \
        php7.3-xml \
        php7.3-zip \
        php7.3-uopz

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/7.3/cli/php.ini

# Disable session upload progress
RUN echo "session.upload_progress.enabled = Off" >> /etc/php/7.3/cli/php.ini
RUN echo "uopz.exit = 1" >> /etc/php/7.3/mods-available/uopz.ini

COPY ./test.php /tmp/test.php
COPY ./run_tests.sh /tmp/test.sh

RUN chmod +x /tmp/test.sh && /tmp/test.sh

ENTRYPOINT [ "entrypoint-cli" ]
