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
- `opentelemetry` (pre-compiled in `mods-available`, disabled by default; enable via `phpenmod opentelemetry`)
- `pcntl`
- `protobuf` (pre-compiled in `mods-available`, disabled by default; enable via `phpenmod protobuf`)
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

### FPM image (with automatic system dependencies & per-SAPI extensions)

```dockerfile
FROM sykescottages/php:8.6-src-fpm

# Automatically installs required Ubuntu -dev dependencies, compiles, enables,
# preserves runtime shared libraries, and cleans up temporary -dev packages
RUN php-ext-install gd pdo_pgsql redis

# Install xdebug without enabling it globally, then enable it for CLI only
RUN php-ext-install --no-enable xdebug && \
    phpenmod -s cli xdebug

# Custom PHP configuration
COPY php.ini /etc/php/8.6/fpm/conf.d/99-custom.ini
COPY php.ini /etc/php/8.6/cli/conf.d/99-custom.ini
```

## Installing Extensions with `php-ext-install`

`php-ext-install` supports both **bundled PHP core extensions** (e.g. `gd`, `pdo_pgsql`, `pgsql`, `gmp`, `bz2`, `ldap`, `dba`, `tidy`, `odbc`, `pdo_dblib`) and **PECL extensions** (e.g. `redis`, `apcu`, `xdebug`, `igbinary`, `memcached`, `imagick`, `pcov`, `yaml`, `amqp`, `rdkafka`, `mongodb`).

By default, `php-ext-install`:
1. Automatically installs any required Ubuntu `-dev` apt packages for the requested extensions.
2. Downloads and SHA-256-verifies the exact `8.x.y` source archive matching the image (from `/etc/php/<major.minor>/release.env`) when building bundled core extensions, using sensible default `./configure` flags (e.g. `--with-freetype --with-jpeg --with-webp` for `gd`).
3. Detects `extension=` vs `zend_extension=`, writes `/etc/php/<major.minor>/mods-available/<ext>.ini`, and **enables the extension by default** via `phpenmod`.
4. Preserves runtime shared libraries linked by the compiled `.so` and purges newly installed temporary `-dev` packages and apt lists afterward.

```shell
# Install and enable one or more extensions (system deps handled automatically)
php-ext-install gd pdo_pgsql redis apcu

# Pin a specific PECL version
php-ext-install redis-6.1.0

# Override ./configure flags for bundled core extensions
php-ext-install --configure-args="--with-freetype --with-jpeg" gd

# Set custom INI load priority (default: 20)
php-ext-install --priority=30 igbinary

# Install into mods-available without enabling
php-ext-install --no-enable xdebug

# Install and enable for a single SAPI only
php-ext-install -s cli xdebug

# Skip automatic apt dependency management or keep newly installed -dev packages
php-ext-install --no-deps myext
php-ext-install --keep-deps gd

# List all extensions with manifests for the current PHP version
php-ext-install --list
```

Extension manifests live in `src/cli/manifests/<extension>.manifest.json` (installed to `/usr/local/share/php-ext-install/manifests/` inside the image) and declare supported PHP versions, source (`bundled` or `pecl`), INI priority, Ubuntu build/runtime dependencies, and default `./configure` flags. Unlisted PECL extensions still fall back to `pecl install`.

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

- CLI `memory_limit = -1` (unlimited, matching Debian/Sury CLI default; FPM retains `memory_limit = 128M`)
- `expose_php = Off`
- `cgi.fix_pathinfo = 0` (FPM)
- `security.limit_extensions = .php` (FPM)
- `error_log = /dev/stderr`
- `session.upload_progress.enabled = 0`
- `fatal_error_backtraces = 0`
- FPM listens on `[::]:9000`, preserves environment variables (`clear_env = no`), logs errors to `/dev/stderr`, captures worker output (`catch_workers_output = yes`), and supports restricting FastCGI clients via the optional `FPM_ALLOWED_CLIENTS` environment variable (e.g. `FPM_ALLOWED_CLIENTS=127.0.0.1`).
- Standard binary paths `/usr/bin/php`, `/usr/bin/php<major.minor>`, `/usr/bin/php-fpm`, and `/usr/sbin/php-fpm<major.minor>` are symlinked for compatibility with hardcoded scripts and process managers.
- Run `php-ext-cleanup` at the end of a production Dockerfile (after all `php-ext-install` calls) to purge `build-essential`, `autoconf`, `pkg-config`, PHP build headers, and `pecl`/`pear` from the final runtime image.
