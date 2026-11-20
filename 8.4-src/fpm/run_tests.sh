#!/bin/sh

itShouldCheckThatAllInstalledSoftwareExists() {
    doesCommandExist php-fpm
}

doesCommandExist() {
    if ! [ -x "$(command -v $1)" ]; then
      echo "Error: $1 is not installed." >&2
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
  php -c /etc/php/8.4/fpm/php.ini -r 'exit(get_cfg_var("fatal_error_backtraces") === "0" && !ini_get("fatal_error_backtraces") ? 0 : 1);'
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

itShouldCheckThatAllInstalledSoftwareExists
itShouldDisableSessionUploadProgress
itShouldDisableFatalErrorBacktraces
itShouldToggleModulesWithPhpenmodAndPhpdismod
