FROM sykescottages/base

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime 

RUN add-apt-repository ppa:ondrej/php

RUN mkdir /composer

RUN curl -L https://getcomposer.org/installer > /composer/composer-setup.php && \
    echo "e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a /composer/composer-setup.php" | sha384sum --check;