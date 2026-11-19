# PHP 8.6 Docker Images

Unlike PHP 8.5 and earlier, the PHP 8.6 images (`sykescottages/php:8.6-cli` and `sykescottages/php:8.6-fpm`) are built directly from official PHP source on top of `sykescottages/base:ubuntu-24-04` without `ppa:ondrej/php`. Each build automatically resolves and verifies the latest `8.6.x` patch release from php.net.

Because `ondrej` apt packages (`php8.6-*`) are not used, PHP 8.6 provides `php-ext-install`, `phpenmod`, and `phpdismod` for installing and managing extensions.

## Available Tags

- `sykescottages/php:8.6-cli` (CLI + Composer)
- `sykescottages/php:8.6-fpm` (extends `8.6-cli` with PHP-FPM listening on port `9000`)

Both tags support `linux/amd64` and `linux/arm64/v8`.

## Pre-installed Extensions

- `bcmath`
- `calendar`
- `curl`
- `decimal` (built with `mpdecimal`, managed via `phpenmod`/`phpdismod`)
- `exif`
- `ffi`
- `ftp`
- `gettext`
- `intl`
- `json`
- `mbstring`
- `mysqli` & `pdo_mysql` (`mysqlnd`)
- `openssl`
- `pcntl`
- `readline` (CLI)
- `shmop`
- `soap`
- `sockets`
- `sodium`
- `sysvmsg`, `sysvsem`, `sysvshm`
- `xml` (`dom`, `simplexml`, `xmlreader`, `xmlwriter`, `xsl`)
- `Zend OPcache`
- `zip`
- `zlib`

`phpize`, `php-config`, `pecl`, `autoconf`, `build-essential`, and `pkg-config` are also included so extensions can be compiled directly in downstream Dockerfiles.

## Using PHP 8.6 in a Dockerfile

### CLI image

```dockerfile
FROM sykescottages/php:8.6-cli

# Install PECL extensions (automatically enabled for CLI)
RUN php-ext-install redis apcu

WORKDIR /app
COPY . /app
```

### FPM image (with system libraries & per-SAPI extensions)

```dockerfile
FROM sykescottages/php:8.6-fpm

# Install any native C libraries required by the extensions you want to compile
RUN apt-get update && \
    apt-get install -y -q --no-install-recommends \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libpq-dev && \
    php-ext-install --configure-args="--with-freetype --with-jpeg" gd && \
    php-ext-install pdo_pgsql redis && \
    apt-get autoremove -y -q && \
    apt-get autoclean -y -q && \
    rm -rf /var/lib/apt/lists/*

# Install xdebug without enabling it globally, then enable it for CLI only
RUN php-ext-install --no-enable xdebug && \
    phpenmod -s cli xdebug

# Custom PHP configuration
COPY php.ini /etc/php/8.6/fpm/conf.d/99-custom.ini
COPY php.ini /etc/php/8.6/cli/conf.d/99-custom.ini
```

## Installing Extensions with `php-ext-install`

`php-ext-install` supports both **bundled PHP 8.6 core extensions** (e.g. `gd`, `pdo_pgsql`, `pgsql`, `gmp`, `bz2`, `ldap`, `dba`) and **PECL extensions** (e.g. `redis`, `apcu`, `xdebug`, `igbinary`, `memcached`, `imagick`, `pcov`).

When installing a bundled core extension, it downloads and SHA-256-verifies the exact `8.6.x` source archive matching the image (from `/etc/php/8.6/release.env`), compiles the extension, and removes the temporary source directory. It automatically detects `extension=` vs `zend_extension=`, writes `/etc/php/8.6/mods-available/<ext>.ini`, and enables the module via `phpenmod`.

```shell
# Install one or more extensions
php-ext-install redis apcu

# Pin a specific PECL version
php-ext-install redis-6.1.0

# Pass ./configure flags for bundled core extensions
php-ext-install --configure-args="--with-freetype --with-jpeg" gd

# Set custom INI load priority (default: 20)
php-ext-install --priority=30 igbinary

# Install into mods-available without enabling
php-ext-install --no-enable xdebug

# Install and enable for a single SAPI only
php-ext-install -s cli xdebug
```

## Managing Modules with `phpenmod` and `phpdismod`

PHP 8.6 includes `phpenmod` and `phpdismod` scoped to `/etc/php/8.6/`:

```shell
# Enable or disable a module across all installed SAPIs (cli, and fpm in the FPM image)
phpenmod decimal
phpdismod decimal

# Target a specific SAPI only
phpenmod -s cli xdebug
phpdismod -s fpm xdebug

# Override the INI priority
phpenmod decimal/30
```

## Configuration Paths

- **CLI `php.ini`:** `/etc/php/8.6/cli/php.ini`
- **CLI scan dir:** `/etc/php/8.6/cli/conf.d/`
- **FPM `php.ini`:** `/etc/php/8.6/fpm/php.ini`
- **FPM scan dir:** `/etc/php/8.6/fpm/conf.d/`
- **FPM config:** `/etc/php/8.6/fpm/php-fpm.conf` and `/etc/php/8.6/fpm/pool.d/www.conf`
- **Available modules:** `/etc/php/8.6/mods-available/`
- **Pinned release metadata:** `/etc/php/8.6/release.env`

## Security & Logging Defaults

- `error_log = /dev/stderr`
- `session.upload_progress.enabled = 0`
- `fatal_error_backtraces = 0`
- FPM listens on `[::]:9000`, preserves environment variables (`clear_env = no`), logs errors to `/dev/stderr`, and captures worker output (`catch_workers_output = yes`).
