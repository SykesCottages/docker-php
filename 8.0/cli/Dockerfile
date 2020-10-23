FROM sykescottages/php:base

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

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

RUN php /composer/composer-setup.php && \
    rm /composer/composer-setup.php && \
    mv composer.phar /usr/bin/composer
