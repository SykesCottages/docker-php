FROM sykescottages/base

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update; \
    apt-get install -yy \
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

RUN apt-get autoremove; \
    apt-get clean -yy

COPY ./install-composer.php install-composer.php
RUN php install-composer.php
RUN php composer-setup.php
RUN rm composer-setup.php
RUN mv composer.phar /usr/bin/composer

COPY entrypoint /usr/local/bin/
ENTRYPOINT [ "entrypoint" ]