FROM sykescottages/base

RUN add-apt-repository ppa:ondrej/php

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

RUN apt-get autoremove; \
    apt-get clean -yy

RUN curl -L https://getcomposer.org/installer > /tmp/composer-setup.php; \
    echo "e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a /tmp/composer-setup.php" | sha384sum --check; \
    php /tmp/composer-setup.php; \
    rm /tmp/composer-setup.php; \
    mv composer.phar /usr/bin/composer

COPY entrypoint /usr/local/bin/
ENTRYPOINT [ "entrypoint" ]