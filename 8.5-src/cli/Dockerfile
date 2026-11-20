ARG ARCH=amd64
FROM sykescottages/base:ubuntu-24-04-$ARCH AS builder

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
    mkdir -p /usr/src/php /etc/php/8.5/cli/conf.d /etc/php/8.5/mods-available; \
    RELEASE_JSON="$(curl -fsSL "https://www.php.net/releases/index.php?json&version=8.5")"; \
    PHP_VERSION="$(printf '%s' "$RELEASE_JSON" | jq -er '.version')"; \
    PHP_FILENAME="$(printf '%s' "$RELEASE_JSON" | jq -er '.source[] | select(.filename | endswith(".tar.xz")) | .filename')"; \
    PHP_SHA256="$(printf '%s' "$RELEASE_JSON" | jq -er '.source[] | select(.filename | endswith(".tar.xz")) | .sha256')"; \
    printf 'PHP_VERSION=%s\nPHP_SHA256=%s\n' "$PHP_VERSION" "$PHP_SHA256" > /etc/php/8.5/release.env; \
    curl -fsSL "https://www.php.net/distributions/${PHP_FILENAME}" -o /tmp/php.tar.xz; \
    echo "${PHP_SHA256}  /tmp/php.tar.xz" | sha256sum -c -; \
    tar -xf /tmp/php.tar.xz -C /usr/src/php --strip-components=1; \
    rm -f /tmp/php.tar.xz; \
    cd /usr/src/php; \
    ./configure \
        --prefix=/usr/local \
        --with-config-file-path=/etc/php/8.5/cli \
        --with-config-file-scan-dir=/etc/php/8.5/cli/conf.d \
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
    cp php.ini-production /etc/php/8.5/cli/php.ini; \
    rm -rf /usr/src/php

RUN set -eux; \
    mkdir -p /tmp/mpdecimal; \
    cd /tmp/mpdecimal; \
    curl -fsSL https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-4.0.1.tar.gz | tar -xz --strip-components=1; \
    ./configure --prefix=/usr/local; \
    make -j"$(nproc)"; \
    make install; \
    ldconfig; \
    rm -rf /tmp/mpdecimal; \
    mkdir -p /tmp/decimal; \
    cd /tmp/decimal; \
    curl -fsSL https://github.com/php-decimal/ext-decimal/archive/8208d89.tar.gz | tar -xz --strip-components=1; \
    sed -i 's/ZEND_PARSE_PARAMETERS_START_EX(ZEND_PARSE_PARAMS_THROW, min, max)/ZEND_PARSE_PARAMETERS_START(min, max)/g' src/params.h; \
    phpize; \
    ./configure; \
    make -j"$(nproc)"; \
    make install; \
    rm -rf /tmp/decimal; \
    printf '; priority=30\nextension=decimal.so\n' > /etc/php/8.5/mods-available/decimal.ini

FROM sykescottages/base:ubuntu-24-04-$ARCH

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

RUN apt-get update -y && \
    apt-get install -y -q --no-install-recommends \
        autoconf \
        build-essential \
        ca-certificates \
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
        pkg-config \
        zlib1g && \
    apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY --from=builder /usr/local/include/php/ /usr/local/include/php/
COPY --from=builder /usr/local/lib/php/ /usr/local/lib/php/
COPY --from=builder /usr/local/lib/libmpdec* /usr/local/lib/
COPY --from=builder /usr/local/php/ /usr/local/php/
COPY --from=builder /etc/php/8.5/ /etc/php/8.5/
RUN ldconfig

COPY entrypoint-cli phpenmod phpdismod php-ext-install /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint-cli /usr/local/bin/phpenmod /usr/local/bin/phpdismod /usr/local/bin/php-ext-install

RUN phpenmod decimal

# Enable Error Logs
RUN echo "error_log = /dev/stderr" >> /etc/php/8.5/cli/php.ini

# Disable session upload progress
RUN echo "session.upload_progress.enabled = 0" >> /etc/php/8.5/cli/php.ini

# Disable fatal error backtraces
RUN echo "fatal_error_backtraces = 0" >> /etc/php/8.5/cli/php.ini

ENTRYPOINT [ "entrypoint-cli" ]
