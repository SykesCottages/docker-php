FROM sykescottages/php:8.0-cli

RUN apt-get update && \
    apt-get install -y -q \
        php8.0-fpm

RUN apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/sbin/php-fpm8.0 /usr/bin/php-fpm
RUN mkdir -p /run/php

# FPM Socket Settings
RUN sed -i 's/\(listen = *\)[^ ]*/\1[::]:9000/g' /etc/php/8.0/fpm/pool.d/www.conf
RUN sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/8.0/fpm/pool.d/www.conf

# Enable PHP Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/8.0/fpm/php.ini

# Enable FPM Logs
RUN sed -i 's|\(error_log =\).*|\1 /dev/stderr|g' /etc/php/8.0/fpm/php-fpm.conf

# Enable Pool Error Logs
RUN sed -i 's|;catch_workers_output = yes|catch_workers_output = yes|g' /etc/php/8.0/fpm/pool.d/www.conf
#RUN sed -i 's|access.log =.*|access.log = /dev/stdout|g' /etc/php/8.0/fpm/pool.d/www.conf

# Enable Child Error Ouput
RUN echo "php_admin_flag[log_errors] = on" >> /etc/php/8.0/fpm/pool.d/www.conf
RUN echo "php_admin_flag[display_errors] = off" >> /etc/php/8.0/fpm/pool.d/www.conf
RUN echo "php_admin_value[error_reporting] = E_ALL & ~E_NOTICE & ~E_WARNING & ~E_STRICT & ~E_DEPRECATED" >> /etc/php/8.0/fpm/pool.d/www.conf
RUN echo "php_admin_value[error_log] = /dev/stderr" >> /etc/php/8.0/fpm/pool.d/www.conf

ENTRYPOINT [ "entrypoint-fpm" ]

EXPOSE 9000
CMD ["php-fpm", "-F"]