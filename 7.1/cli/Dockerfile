FROM sykescottages/base

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update; \
    apt-get install -yy \
        php7.1 \
        php7.1-bcmath \
        php7.1-curl \
        php7.1-dev \
        php7.1-intl \
        php7.1-json \
        php7.1-mbstring \
        php7.1-mysql \
        php7.1-soap \
        php7.1-xml \
        php7.1-zip

RUN apt-get autoremove; \
    apt-get clean -yy

COPY ./install-composer.php install-composer.php
RUN php install-composer.php
RUN php composer-setup.php
RUN rm composer-setup.php
RUN mv composer.phar /usr/bin/composer

COPY entrypoint /usr/local/bin/
ENTRYPOINT [ "entrypoint" ]