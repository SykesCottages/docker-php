FROM sykescottages/php:7.3-cli

RUN apt-get update && \
    apt-get install -y -q \
        php7.3-fpm

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/sbin/php-fpm7.3 /usr/bin/php-fpm
RUN mkdir -p /run/php

RUN sed -i 's/\(listen = *\)[^ ]*/\1[::]:9000/g' /etc/php/7.3/fpm/pool.d/www.conf
RUN sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/7.3/fpm/pool.d/www.conf

RUN sed -i 's|\(error_log =\).*|\1 /proc/self/fd/2|g' /etc/php/7.3/fpm/php-fpm.conf
RUN sed -i 's|;access.log =.*|access.log = /proc/self/fd/2|g' /etc/php/7.3/fpm/pool.d/www.conf

ENTRYPOINT [ "entrypoint-fpm" ]

EXPOSE 9000
CMD ["php-fpm", "-F"]