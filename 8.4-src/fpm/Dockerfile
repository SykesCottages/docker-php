ARG ARCH=amd64
FROM sykescottages/php:8.4-src-cli-$ARCH AS builder

RUN apt-get update -y && \
    apt-get install -y -q --no-install-recommends \
        bison \
        ca-certificates \
        curl \
        libargon2-dev \
        libcurl4-openssl-dev \
        libffi-dev \
        libicu-dev \
        libonig-dev \
        libsodium-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        libxslt1-dev \
        libzip-dev \
        re2c \
        xz-utils \
        zlib1g-dev

RUN set -eux; \
    . /etc/php/8.4/release.env; \
    mkdir -p /usr/src/php /etc/php/8.4/fpm/conf.d /etc/php/8.4/fpm/pool.d; \
    curl -fsSL "https://www.php.net/distributions/php-${PHP_VERSION}.tar.xz" -o /tmp/php.tar.xz; \
    echo "${PHP_SHA256}  /tmp/php.tar.xz" | sha256sum -c -; \
    tar -xf /tmp/php.tar.xz -C /usr/src/php --strip-components=1; \
    rm -f /tmp/php.tar.xz; \
    cd /usr/src/php; \
    ./configure \
        --prefix=/usr/local \
        --sysconfdir=/etc/php/8.4/fpm \
        --with-config-file-path=/etc/php/8.4/fpm \
        --with-config-file-scan-dir=/etc/php/8.4/fpm/conf.d \
        --enable-fpm \
        --with-fpm-user=www-data \
        --with-fpm-group=www-data \
        --disable-cli \
        --disable-cgi \
        --disable-phpdbg \
        --without-pear \
        --enable-bcmath \
        --enable-calendar \
        --enable-exif \
        --enable-ftp \
        --enable-intl \
        --enable-mbstring \
        --enable-mysqlnd \
        --enable-pcntl \
        --enable-shmop \
        --enable-soap \
        --enable-sockets \
        --enable-sysvmsg \
        --enable-sysvsem \
        --enable-sysvshm \
        --with-curl \
        --with-ffi \
        --with-gettext \
        --with-mysqli=mysqlnd \
        --with-openssl \
        --with-password-argon2 \
        --with-pdo-mysql=mysqlnd \
        --with-sodium \
        --with-xsl \
        --with-zip \
        --with-zlib; \
    make -j"$(nproc)"; \
    make install-fpm; \
    cp php.ini-production /etc/php/8.4/fpm/php.ini; \
    cp /etc/php/8.4/fpm/php-fpm.conf.default /etc/php/8.4/fpm/php-fpm.conf; \
    sed -i 's|;pid = run/php-fpm.pid|pid = /run/php/php8.4-fpm.pid|g' /etc/php/8.4/fpm/php-fpm.conf; \
    sed -i 's|include=/etc/php/8.4/fpm/php-fpm.d/\*.conf|include=/etc/php/8.4/fpm/pool.d/*.conf|g' /etc/php/8.4/fpm/php-fpm.conf; \
    cp /etc/php/8.4/fpm/php-fpm.d/www.conf.default /etc/php/8.4/fpm/pool.d/www.conf; \
    rm -rf /etc/php/8.4/fpm/php-fpm.d /etc/php/8.4/fpm/php-fpm.conf.default /usr/src/php

FROM sykescottages/php:8.4-src-cli-$ARCH

COPY entrypoint-fpm /usr/local/bin/entrypoint-fpm
RUN chmod +x /usr/local/bin/entrypoint-fpm

COPY --from=builder /usr/local/sbin/php-fpm /usr/local/sbin/php-fpm
COPY --from=builder /etc/php/8.4/fpm/ /etc/php/8.4/fpm/

RUN cp -a /etc/php/8.4/cli/conf.d/. /etc/php/8.4/fpm/conf.d/

RUN ln -sf /usr/local/sbin/php-fpm /usr/sbin/php-fpm8.4 && \
    ln -sf /usr/sbin/php-fpm8.4 /usr/bin/php-fpm
RUN mkdir -p /run/php

# FPM Socket Settings
RUN sed -i 's/\(listen = *\)[^ ]*/\1[::]:9000/g' /etc/php/8.4/fpm/pool.d/www.conf
RUN sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/8.4/fpm/pool.d/www.conf

# Enable PHP Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/8.4/fpm/php.ini

# Disable session upload progress
RUN echo "session.upload_progress.enabled = 0" >> /etc/php/8.4/fpm/php.ini

# Disable fatal error backtraces
RUN echo "fatal_error_backtraces = 0" >> /etc/php/8.4/fpm/php.ini

# Enable FPM Logs
RUN sed -i 's|;\?\(error_log =\).*|\1 /dev/stderr|g' /etc/php/8.4/fpm/php-fpm.conf

# Enable Pool Error Logs
RUN sed -i 's|;catch_workers_output = yes|catch_workers_output = yes|g' /etc/php/8.4/fpm/pool.d/www.conf
#RUN sed -i 's|access.log =.*|access.log = /dev/stdout|g' /etc/php/8.4/fpm/pool.d/www.conf

# Enable Child Error Output
RUN echo "php_admin_flag[log_errors] = on" >> /etc/php/8.4/fpm/pool.d/www.conf
RUN echo "php_admin_flag[display_errors] = off" >> /etc/php/8.4/fpm/pool.d/www.conf
RUN echo "php_admin_value[error_reporting] = E_ALL & ~E_NOTICE & ~E_WARNING & ~E_STRICT & ~E_DEPRECATED" >> /etc/php/8.4/fpm/pool.d/www.conf
RUN echo "php_admin_value[error_log] = /dev/stderr" >> /etc/php/8.4/fpm/pool.d/www.conf

ENTRYPOINT [ "entrypoint-fpm" ]

EXPOSE 9000
CMD ["php-fpm", "-F"]
