FROM sykescottages/base

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime 

RUN add-apt-repository ppa:ondrej/php

RUN mkdir /composer

RUN curl -L https://getcomposer.org/download/1.10.15/composer.phar > /composer/composer-setup.php && \
    echo "67aeceddcb38018de9b3cb9cda4ebb20d0b4167ca106a0a2f83a49c40b4d800a6004eb6e790f638ef689d734488d25cf /composer/composer-setup.php" | sha384sum --check;

COPY entrypoint /usr/local/bin/

ENTRYPOINT [ "entrypoint" ]