ARG ARCH=amd64
ARG PHP_VERSION=8.6
FROM sykescottages/base:ubuntu-24-04-$ARCH AS builder

ARG PHP_VERSION

RUN apt-get update -y && \
    apt-get install -y -q --no-install-recommends \
        autoconf \
        bison \
        build-essential \
        ca-certificates \
        curl \
        jq \
        libargon2-dev \
        libcurl4-openssl-dev \
        libffi-dev \
        libicu-dev \
        libonig-dev \
        libreadline-dev \
        libsodium-dev \
        libsqlite3-dev \
        libssl-dev \
        libxml2-dev \
        libxslt1-dev \
        libzip-dev \
        pkg-config \
        re2c \
        xz-utils \
        zlib1g-dev

RUN set -eux; \
    mkdir -p /usr/src/php /etc/php/${PHP_VERSION}/cli/conf.d /etc/php/${PHP_VERSION}/mods-available; \
    RELEASE_JSON="$(curl -fsSL "https://www.php.net/releases/index.php?json&version=${PHP_VERSION}")"; \
    PHP_FULL_VERSION="$(printf '%s' "$RELEASE_JSON" | jq -er '.version')"; \
    PHP_FILENAME="$(printf '%s' "$RELEASE_JSON" | jq -er '.source[] | select(.filename | endswith(".tar.xz")) | .filename')"; \
    PHP_SHA256="$(printf '%s' "$RELEASE_JSON" | jq -er '.source[] | select(.filename | endswith(".tar.xz")) | .sha256')"; \
    printf '%s' "$PHP_FULL_VERSION" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; \
    printf '%s' "$PHP_FILENAME" | grep -Eq '^php-[0-9]+\.[0-9]+\.[0-9]+\.tar\.xz$'; \
    printf '%s' "$PHP_SHA256" | grep -Eq '^[0-9a-f]{64}$'; \
    printf 'PHP_VERSION=%s\nPHP_SHA256=%s\n' "$PHP_FULL_VERSION" "$PHP_SHA256" > /etc/php/${PHP_VERSION}/release.env; \
    curl -fsSL "https://www.php.net/distributions/${PHP_FILENAME}" -o /tmp/php.tar.xz; \
    echo "${PHP_SHA256}  /tmp/php.tar.xz" | sha256sum -c -; \
    tar -xf /tmp/php.tar.xz -C /usr/src/php --strip-components=1; \
    rm -f /tmp/php.tar.xz; \
    cd /usr/src/php; \
    ./configure \
        --prefix=/usr/local \
        --with-config-file-path=/etc/php/${PHP_VERSION}/cli \
        --with-config-file-scan-dir=/etc/php/${PHP_VERSION}/cli/conf.d \
        --disable-cgi \
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
        --with-pear \
        --with-readline \
        --with-sodium \
        --with-xsl \
        --with-zip \
        --with-zlib; \
    make -j"$(nproc)"; \
    make install; \
    cp php.ini-production /etc/php/${PHP_VERSION}/cli/php.ini; \
    sed -i 's/^memory_limit = .*/memory_limit = -1/' /etc/php/${PHP_VERSION}/cli/php.ini; \
    rm -rf /usr/src/php

RUN set -eux; \
    MPDECIMAL_SHA256="96d33abb4bb0070c7be0fed4246cd38416188325f820468214471938545b1ac8"; \
    EXT_DECIMAL_COMMIT="8208d89740c48f04673a75f233f4ffaa307322d0"; \
    EXT_DECIMAL_SHA256="8adbf1e13094dceaca2a502a11d9573f7db55f1da65c5475c711f22958014e58"; \
    mkdir -p /tmp/mpdecimal; \
    curl -fsSL https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-4.0.1.tar.gz -o /tmp/mpdecimal.tar.gz; \
    echo "${MPDECIMAL_SHA256}  /tmp/mpdecimal.tar.gz" | sha256sum -c -; \
    tar -xzf /tmp/mpdecimal.tar.gz -C /tmp/mpdecimal --strip-components=1; \
    rm -f /tmp/mpdecimal.tar.gz; \
    cd /tmp/mpdecimal; \
    ./configure --prefix=/usr/local; \
    make -j"$(nproc)"; \
    make install; \
    ldconfig; \
    rm -rf /tmp/mpdecimal; \
    mkdir -p /tmp/decimal; \
    curl -fsSL "https://github.com/php-decimal/ext-decimal/archive/${EXT_DECIMAL_COMMIT}.tar.gz" -o /tmp/decimal.tar.gz; \
    echo "${EXT_DECIMAL_SHA256}  /tmp/decimal.tar.gz" | sha256sum -c -; \
    tar -xzf /tmp/decimal.tar.gz -C /tmp/decimal --strip-components=1; \
    rm -f /tmp/decimal.tar.gz; \
    cd /tmp/decimal; \
    sed -i 's/ZEND_PARSE_PARAMETERS_START_EX(ZEND_PARSE_PARAMS_THROW, min, max)/ZEND_PARSE_PARAMETERS_START(min, max)/g' src/params.h; \
    if grep -q 'zend_ini_long_literal' /usr/local/include/php/Zend/zend_ini.h; then \
        sed -i 's/INI_INT(/zend_ini_long_literal(/g' php_decimal.c; \
    fi; \
    phpize; \
    ./configure; \
    make -j"$(nproc)"; \
    make install; \
    rm -rf /tmp/decimal; \
    pecl channel-update pecl.php.net; \
    yes '' | pecl install opentelemetry protobuf; \
    rm -rf /tmp/pear; \
    strip --strip-unneeded /usr/local/bin/php "$(php-config --extension-dir)"/*.so 2>/dev/null || true; \
    if [ -f "$(php-config --extension-dir)/opcache.so" ]; then \
        printf '; priority=10\nzend_extension=opcache.so\n' > /etc/php/${PHP_VERSION}/mods-available/opcache.ini; \
    fi; \
    printf '; priority=20\nextension=opentelemetry.so\n' > /etc/php/${PHP_VERSION}/mods-available/opentelemetry.ini; \
    printf '; priority=30\nextension=decimal.so\n' > /etc/php/${PHP_VERSION}/mods-available/decimal.ini; \
    printf '; priority=30\nextension=protobuf.so\n' > /etc/php/${PHP_VERSION}/mods-available/protobuf.ini

FROM sykescottages/base:ubuntu-24-04-$ARCH

ARG PHP_VERSION

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

RUN apt-get update -y && \
    apt-get install -y -q --no-install-recommends \
        autoconf \
        build-essential \
        ca-certificates \
        curl \
        libargon2-1 \
        libcurl4t64 \
        libffi8 \
        libicu74 \
        libonig5 \
        libreadline8t64 \
        libsodium23 \
        libsqlite3-0 \
        libssl3t64 \
        libxml2 \
        libxslt1.1 \
        libzip4t64 \
        lsb-release \
        pkg-config \
        xz-utils \
        zlib1g && \
    apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY --from=builder /usr/local/include/php/ /usr/local/include/php/
COPY --from=builder /usr/local/lib/php/ /usr/local/lib/php/
COPY --from=builder /usr/local/lib/libmpdec* /usr/local/lib/
COPY --from=builder /usr/local/php/ /usr/local/php/
COPY --from=builder /etc/php/${PHP_VERSION}/ /etc/php/${PHP_VERSION}/
RUN ldconfig && \
    ln -sf /usr/local/bin/php /usr/bin/php && \
    ln -sf /usr/local/bin/php /usr/bin/php${PHP_VERSION} && \
    ln -sf /usr/local/bin/phpize /usr/bin/phpize && \
    ln -sf /usr/local/bin/phpize /usr/bin/phpize${PHP_VERSION} && \
    ln -sf /usr/local/bin/php-config /usr/bin/php-config && \
    ln -sf /usr/local/bin/php-config /usr/bin/php-config${PHP_VERSION} && \
    ln -sf /usr/local/bin/phar /usr/bin/phar && \
    ln -sf /usr/local/bin/phar /usr/bin/phar${PHP_VERSION} && \
    ln -sf /usr/local/bin/pecl /usr/bin/pecl && \
    ln -sf /usr/local/bin/pear /usr/bin/pear

COPY entrypoint-cli phpenmod phpdismod php-ext-install php-ext-cleanup /usr/local/bin/
COPY manifests/ /usr/local/share/php-ext-install/manifests/
RUN chmod +x /usr/local/bin/entrypoint-cli /usr/local/bin/phpenmod /usr/local/bin/phpdismod /usr/local/bin/php-ext-install /usr/local/bin/php-ext-cleanup

RUN if [ -f "/etc/php/${PHP_VERSION}/mods-available/opcache.ini" ]; then phpenmod opcache; fi && \
    phpenmod decimal

# Security & Logging Defaults
RUN sed -i 's/^expose_php = .*/expose_php = Off/' /etc/php/${PHP_VERSION}/cli/php.ini && \
    echo "error_log = /dev/stderr" >> /etc/php/${PHP_VERSION}/cli/php.ini && \
    echo "session.upload_progress.enabled = 0" >> /etc/php/${PHP_VERSION}/cli/php.ini && \
    echo "fatal_error_backtraces = 0" >> /etc/php/${PHP_VERSION}/cli/php.ini

ENTRYPOINT [ "entrypoint-cli" ]
