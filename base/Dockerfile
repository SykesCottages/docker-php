FROM sykescottages/base

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime 

RUN add-apt-repository ppa:ondrej/php

RUN mkdir /composer

RUN curl -L https://getcomposer.org/download/1.10.15/composer.phar > /composer/composer-setup.php && \
    echo "c31c1e292ad7be5f49291169c0ac8f683499edddcfd4e42232982d0fd193004208a58ff6f353fde0012d35fdd72bc394 /composer/composer-setup.php" | sha384sum --check;

COPY entrypoint /usr/local/bin/

ENTRYPOINT [ "entrypoint" ]