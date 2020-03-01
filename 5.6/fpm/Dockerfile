FROM sykescottages/php:5.6-cli

RUN apt-get update; \
    apt-get install -yy \
        php5.6-fpm

RUN ln -s /usr/sbin/php-fpm5.6 /usr/bin/php-fpm
RUN mkdir -p /run/php
RUN sed -i 's/\(listen = *\)[^ ]*/\1[::]:9000/g' /etc/php/5.6/fpm/pool.d/www.conf

COPY entrypoint /usr/local/bin/
ENTRYPOINT [ "entrypoint" ]

EXPOSE 9000
CMD ["php-fpm", "-F"]