FROM sykescottages/php:7.2-cli

RUN apt-get update && \
    apt-get install -y -q \
        php7.2-fpm

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/sbin/php-fpm7.2 /usr/bin/php-fpm
RUN mkdir -p /run/php
RUN sed -i 's/\(listen = *\)[^ ]*/\1[::]:9000/g' /etc/php/7.2/fpm/pool.d/www.conf
RUN sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/7.2/fpm/pool.d/www.conf

COPY entrypoint /usr/local/bin/
ENTRYPOINT [ "entrypoint" ]

EXPOSE 9000
CMD ["php-fpm", "-F"]