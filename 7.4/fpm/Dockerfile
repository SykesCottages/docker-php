FROM sykescottages/php:7.4-cli

RUN apt-get update; \
    apt-get install -yy \
        php7.4-fpm

RUN ln -s /usr/sbin/php-fpm7.4 /usr/bin/php-fpm
RUN mkdir -p /run/php
RUN sed -i 's/\(listen = *\)[^ ]*/\1[::]:9000/g' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/7.4/fpm/pool.d/www.conf

COPY entrypoint /usr/local/bin/
ENTRYPOINT [ "entrypoint" ]

EXPOSE 9000
CMD ["php-fpm", "-F"]