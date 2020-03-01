FROM sykescottages/base

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update; \
    apt-get install -yy \
        php7.0 \
        php7.0-bcmath \
        php7.0-curl \
        php7.0-dev \
        php7.0-intl \
        php7.0-json \
        php7.0-mbstring \
        php7.0-mysql \
        php7.0-soap \
        php7.0-xml \
        php7.0-zip

RUN apt-get autoremove; \
    apt-get clean -yy

COPY ./install-composer.php install-composer.php
RUN php install-composer.php
RUN php composer-setup.php
RUN rm composer-setup.php
RUN mv composer.phar /usr/bin/composer

COPY entrypoint /usr/local/bin/
ENTRYPOINT [ "entrypoint" ]