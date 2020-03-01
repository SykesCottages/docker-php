FROM sykescottages/base

RUN apt-get update; \
    apt-get install -yy \
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

# Composer
COPY ./install-composer.php install-composer.php
RUN php install-composer.php

RUN php composer-setup.php
RUN rm composer-setup.php
RUN mv composer.phar /usr/bin/composer

ENTRYPOINT ["php"]
