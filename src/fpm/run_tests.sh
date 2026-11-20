#!/bin/sh

PHP_VERSION="${PHP_VERSION:-$(php -r 'echo PHP_MAJOR_VERSION . "." . PHP_MINOR_VERSION;')}"

itShouldCheckThatAllInstalledSoftwareExists() {
    doesCommandExist php-fpm
    doesExecutablePathExist /usr/bin/php-fpm
    doesExecutablePathExist "/usr/sbin/php-fpm${PHP_VERSION}"
}

doesCommandExist() {
    if ! [ -x "$(command -v "$1")" ]; then
      echo "Error: $1 is not installed." >&2
      exit 1
    fi
}

doesExecutablePathExist() {
    if ! [ -x "$1" ]; then
      echo "Error: $1 is not executable." >&2
      exit 1
    fi
}

itShouldDisableSessionUploadProgress() {
  php-fpm -i 2>/dev/null | grep -F 'session.upload_progress.enabled' | grep -q '=> Off => Off'
  if [ $? -ne 0 ]; then
    echo "Error: session.upload_progress.enabled is not Off." >&2
    exit 1
  fi
}

itShouldDisableFatalErrorBacktraces() {
  php -c "/etc/php/${PHP_VERSION}/fpm/php.ini" -r 'exit(get_cfg_var("fatal_error_backtraces") === "0" && !ini_get("fatal_error_backtraces") ? 0 : 1);'
  if [ $? -ne 0 ]; then
    echo "Error: fatal_error_backtraces is not Off." >&2
    exit 1
  fi
}

itShouldToggleModulesWithPhpenmodAndPhpdismod() {
  phpdismod decimal
  if php-fpm -m 2>/dev/null | grep -q -e "^decimal$"; then
    echo "Error: phpdismod failed to disable decimal in FPM." >&2
    exit 1
  fi

  phpenmod decimal
  if ! php-fpm -m 2>/dev/null | grep -q -e "^decimal$"; then
    echo "Error: phpenmod failed to re-enable decimal in FPM." >&2
    exit 1
  fi
}

itShouldHardenFpmDefaults() {
  php -c "/etc/php/${PHP_VERSION}/fpm/php.ini" -r 'exit(!ini_get("expose_php") && !ini_get("cgi.fix_pathinfo") ? 0 : 1);'
  if [ $? -ne 0 ]; then
    echo "Error: FPM expose_php or cgi.fix_pathinfo is not Off." >&2
    exit 1
  fi
  if ! grep -Eq '^security\.limit_extensions = \.php$' "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"; then
    echo "Error: FPM security.limit_extensions is not set to .php." >&2
    exit 1
  fi
}

itShouldCheckThatAllInstalledSoftwareExists
itShouldHardenFpmDefaults
itShouldDisableSessionUploadProgress
itShouldDisableFatalErrorBacktraces
itShouldToggleModulesWithPhpenmodAndPhpdismod
