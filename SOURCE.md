# Source-Built PHP Docker Images (`-src`)

The `-src` PHP images (`8.2-src` through `8.6-src`) are built directly from official PHP source on top of `sykescottages/base:ubuntu-24-04` without `sury`/`ondrej` PHP apt repositories. Each build automatically resolves and SHA-256-verifies the latest patch release for its minor version from php.net.

For PHP 8.2–8.5, these `-src` tags are published alongside the existing apt-based tags (`8.x-cli` / `8.x-fpm`) so downstream images that still run `apt-get install php8.x-*` continue to work unchanged.

Because apt PHP packages (`php8.x-*`) are not used, all `-src` images provide `php-ext-install`, `phpenmod`, and `phpdismod` for installing and managing extensions.

## Available Tags

- `sykescottages/php:8.2-src-cli` / `sykescottages/php:8.2-src-fpm`
- `sykescottages/php:8.3-src-cli` / `sykescottages/php:8.3-src-fpm`
- `sykescottages/php:8.4-src-cli` / `sykescottages/php:8.4-src-fpm`
- `sykescottages/php:8.5-src-cli` / `sykescottages/php:8.5-src-fpm`
- `sykescottages/php:8.6-src-cli` / `sykescottages/php:8.6-src-fpm`

All tags support `linux/amd64` and `linux/arm64/v8`. Each `-src-fpm` image extends its corresponding `-src-cli` image with PHP-FPM listening on port `9000`.

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

## Using a `-src` Image in a Dockerfile

(Substitute `8.2`, `8.3`, `8.4`, `8.5`, or `8.6` for `8.6` below.)

### CLI image

```dockerfile
FROM sykescottages/php:8.6-src-cli

# Install PECL extensions (automatically enabled for CLI)
RUN php-ext-install redis apcu

WORKDIR /app
COPY . /app
```

### FPM image (with system libraries & per-SAPI extensions)

```dockerfile
FROM sykescottages/php:8.6-src-fpm

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

`php-ext-install` supports both **bundled PHP core extensions** (e.g. `gd`, `pdo_pgsql`, `pgsql`, `gmp`, `bz2`, `ldap`, `dba`) and **PECL extensions** (e.g. `redis`, `apcu`, `xdebug`, `igbinary`, `memcached`, `imagick`, `pcov`).

When installing a bundled core extension, it downloads and SHA-256-verifies the exact `8.x.y` source archive matching the image (from `/etc/php/<major.minor>/release.env`), compiles the extension, and removes the temporary source directory. It automatically detects `extension=` vs `zend_extension=`, writes `/etc/php/<major.minor>/mods-available/<ext>.ini`, and enables the module via `phpenmod`.

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

Each `-src` image includes `phpenmod` and `phpdismod` scoped to `/etc/php/<major.minor>/`:

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

(Where `<major.minor>` is `8.2`, `8.3`, `8.4`, `8.5`, or `8.6`.)

- **CLI `php.ini`:** `/etc/php/<major.minor>/cli/php.ini`
- **CLI scan dir:** `/etc/php/<major.minor>/cli/conf.d/`
- **FPM `php.ini`:** `/etc/php/<major.minor>/fpm/php.ini`
- **FPM scan dir:** `/etc/php/<major.minor>/fpm/conf.d/`
- **FPM config:** `/etc/php/<major.minor>/fpm/php-fpm.conf` and `/etc/php/<major.minor>/fpm/pool.d/www.conf`
- **Available modules:** `/etc/php/<major.minor>/mods-available/`
- **Pinned release metadata:** `/etc/php/<major.minor>/release.env`

## Security & Logging Defaults

- `error_log = /dev/stderr`
- `session.upload_progress.enabled = 0`
- `fatal_error_backtraces = 0`
- FPM listens on `[::]:9000`, preserves environment variables (`clear_env = no`), logs errors to `/dev/stderr`, and captures worker output (`catch_workers_output = yes`).
