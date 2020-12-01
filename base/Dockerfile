FROM sykescottages/base

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime 

RUN add-apt-repository ppa:ondrej/php

RUN mkdir /composer

RUN curl -L https://getcomposer.org/installer > /composer/composer-setup.php && \
    echo "756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3 /composer/composer-setup.php" | sha384sum --check;

COPY entrypoint-cli /usr/local/bin/
COPY entrypoint-fpm /usr/local/bin/

ENTRYPOINT [ "entrypoint-cli" ]