ARG ARCH=amd64
FROM sykescottages/base:ubuntu-24-04-$ARCH

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime 

RUN apt-get update && \
    apt-get -y install lsb-release ca-certificates curl && curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb && \
    dpkg -i /tmp/debsuryorg-archive-keyring.deb && sh -c 'echo "deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \ 
    apt-get update

COPY entrypoint-cli /usr/local/bin/
COPY entrypoint-fpm /usr/local/bin/

COPY --from=composer /usr/bin/composer /usr/bin/composer
