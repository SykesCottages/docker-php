FROM sykescottages/base

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update; \
    apt-get install -yy \
        php7.3 \
        php7.3-bcmath \
        php7.3-curl \
        php7.3-dev \
        php7.3-intl \
        php7.3-json \
        php7.3-mbstring \
        php7.3-mysql \
        php7.3-soap \
        php7.3-xml \
        php7.3-zip

RUN apt-get autoremove; \
    apt-get clean -yy

COPY ./install-composer.php install-composer.php
RUN php install-composer.php
RUN php composer-setup.php
RUN rm composer-setup.php
RUN mv composer.phar /usr/bin/composer

COPY entrypoint /usr/local/bin/
ENTRYPOINT [ "entrypoint" ]