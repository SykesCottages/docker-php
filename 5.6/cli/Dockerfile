FROM sykescottages/base

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update; \
    apt-get install -yy \
        php5.6 \
        php5.6-bcmath \
        php5.6-curl \
        php5.6-dev \
        php5.6-intl \
        php5.6-json \
        php5.6-mbstring \
        php5.6-mysql \
        php5.6-soap \
        php5.6-xml \
        php5.6-zip

RUN apt-get autoremove; \
    apt-get clean -yy

COPY ./install-composer.php install-composer.php
RUN php install-composer.php
RUN php composer-setup.php
RUN rm composer-setup.php
RUN mv composer.phar /usr/bin/composer

COPY entrypoint /usr/local/bin/
ENTRYPOINT [ "entrypoint" ]