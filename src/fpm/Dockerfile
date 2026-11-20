ARG ARCH=amd64
ARG PHP_VERSION=8.6
FROM sykescottages/php:${PHP_VERSION}-src-cli-$ARCH AS builder

ARG PHP_VERSION

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
    PHP_MINOR="${PHP_VERSION}"; \
    RELEASE_ENV="/etc/php/${PHP_MINOR}/release.env"; \
    PHP_FULL_VERSION="$(awk -F= '$1 == "PHP_VERSION" {print $2; exit}' "$RELEASE_ENV")"; \
    PHP_SHA256="$(awk -F= '$1 == "PHP_SHA256" {print $2; exit}' "$RELEASE_ENV")"; \
    printf '%s' "$PHP_FULL_VERSION" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; \
    printf '%s' "$PHP_SHA256" | grep -Eq '^[0-9a-f]{64}$'; \
    mkdir -p /usr/src/php /etc/php/${PHP_MINOR}/fpm/conf.d /etc/php/${PHP_MINOR}/fpm/pool.d; \
    curl -fsSL "https://www.php.net/distributions/php-${PHP_FULL_VERSION}.tar.xz" -o /tmp/php.tar.xz; \
    echo "${PHP_SHA256}  /tmp/php.tar.xz" | sha256sum -c -; \
    tar -xf /tmp/php.tar.xz -C /usr/src/php --strip-components=1; \
    rm -f /tmp/php.tar.xz; \
    cd /usr/src/php; \
    ./configure \
        --prefix=/usr/local \
        --sysconfdir=/etc/php/${PHP_MINOR}/fpm \
        --with-config-file-path=/etc/php/${PHP_MINOR}/fpm \
        --with-config-file-scan-dir=/etc/php/${PHP_MINOR}/fpm/conf.d \
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
    strip --strip-unneeded /usr/local/sbin/php-fpm 2>/dev/null || true; \
    cp php.ini-production /etc/php/${PHP_MINOR}/fpm/php.ini; \
    cp /etc/php/${PHP_MINOR}/fpm/php-fpm.conf.default /etc/php/${PHP_MINOR}/fpm/php-fpm.conf; \
    sed -i "s|;pid = run/php-fpm.pid|pid = /run/php/php${PHP_MINOR}-fpm.pid|g" /etc/php/${PHP_MINOR}/fpm/php-fpm.conf; \
    sed -i "s|include=/etc/php/${PHP_MINOR}/fpm/php-fpm.d/\*.conf|include=/etc/php/${PHP_MINOR}/fpm/pool.d/*.conf|g" /etc/php/${PHP_MINOR}/fpm/php-fpm.conf; \
    cp /etc/php/${PHP_MINOR}/fpm/php-fpm.d/www.conf.default /etc/php/${PHP_MINOR}/fpm/pool.d/www.conf; \
    rm -rf /etc/php/${PHP_MINOR}/fpm/php-fpm.d /etc/php/${PHP_MINOR}/fpm/php-fpm.conf.default /usr/src/php

FROM sykescottages/php:${PHP_VERSION}-src-cli-$ARCH

ARG PHP_VERSION

COPY entrypoint-fpm /usr/local/bin/entrypoint-fpm
RUN chmod +x /usr/local/bin/entrypoint-fpm

COPY --from=builder /usr/local/sbin/php-fpm /usr/local/sbin/php-fpm
COPY --from=builder /etc/php/${PHP_VERSION}/fpm/ /etc/php/${PHP_VERSION}/fpm/

RUN cp -a /etc/php/${PHP_VERSION}/cli/conf.d/. /etc/php/${PHP_VERSION}/fpm/conf.d/

RUN ln -sf /usr/local/sbin/php-fpm /usr/sbin/php-fpm${PHP_VERSION} && \
    ln -sf /usr/sbin/php-fpm${PHP_VERSION} /usr/bin/php-fpm
RUN mkdir -p /run/php

# FPM Socket & Security Settings
RUN sed -i 's/\(listen = *\)[^ ]*/\1[::]:9000/g' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf && \
    sed -i 's/^;security\.limit_extensions = .*/security.limit_extensions = .php/' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

# PHP Security & Logging Defaults
RUN sed -i 's/^expose_php = .*/expose_php = Off/' /etc/php/${PHP_VERSION}/fpm/php.ini && \
    sed -i 's/^;cgi\.fix_pathinfo=.*/cgi.fix_pathinfo=0/' /etc/php/${PHP_VERSION}/fpm/php.ini && \
    echo "error_log = /dev/stderr" >> /etc/php/${PHP_VERSION}/fpm/php.ini && \
    echo "session.upload_progress.enabled = 0" >> /etc/php/${PHP_VERSION}/fpm/php.ini && \
    echo "fatal_error_backtraces = 0" >> /etc/php/${PHP_VERSION}/fpm/php.ini

# Enable FPM Logs
RUN sed -i 's|;\?\(error_log =\).*|\1 /dev/stderr|g' /etc/php/${PHP_VERSION}/fpm/php-fpm.conf

# Enable Pool Error Logs
RUN sed -i 's|;catch_workers_output = yes|catch_workers_output = yes|g' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
#RUN sed -i 's|access.log =.*|access.log = /dev/stdout|g' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

# Enable Child Error Output
RUN echo "php_admin_flag[log_errors] = on" >> /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
RUN echo "php_admin_flag[display_errors] = off" >> /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
RUN echo "php_admin_value[error_reporting] = E_ALL & ~E_NOTICE & ~E_WARNING & ~E_STRICT & ~E_DEPRECATED" >> /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
RUN echo "php_admin_value[error_log] = /dev/stderr" >> /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

ENTRYPOINT [ "entrypoint-fpm" ]

EXPOSE 9000
CMD ["php-fpm", "-F"]
