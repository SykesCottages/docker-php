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

RUN curl -L https://getcomposer.org/installer > /tmp/composer-setup.php; \
    echo "e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a /tmp/composer-setup.php" | sha384sum --check; \
    php /tmp/composer-setup.php; \
    rm /tmp/composer-setup.php; \
    mv composer.phar /usr/bin/composer

COPY entrypoint /usr/local/bin/
ENTRYPOINT [ "entrypoint" ]