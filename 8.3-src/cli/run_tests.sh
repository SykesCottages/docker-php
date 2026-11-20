#!/bin/sh

PHP_VERSION=8.3

itShouldCheckThatAllInstalledSoftwareExists() {
    doesCommandExist php
    doesCommandExist composer
    doesCommandExist curl
    doesCommandExist lsb_release
    doesCommandExist phpenmod
    doesCommandExist phpdismod
    doesCommandExist php-ext-install
    doesExecutablePathExist /usr/bin/php
    doesExecutablePathExist "/usr/bin/php${PHP_VERSION}"
}

itShouldCheckThatAllPhpModulesExists() {
  doesPhpModuleExist bcmath
  doesPhpModuleExist decimal
  doesPhpModuleExist curl
  doesPhpModuleExist intl
  doesPhpModuleExist json
  doesPhpModuleExist mbstring
  doesPhpModuleExist mysqli
  doesPhpModuleExist soap
  doesPhpModuleExist xml
  doesPhpModuleExist zip
}

itShouldMatchTheDesiredVersionOfPhp() {
  doesPhpMatchVersion $PHP_VERSION
}

doesCommandExist() {
    if ! [ -x "$(command -v $1)" ]; then
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

doesPhpModuleExist() {
    MODULE=$(php -m|grep -e "^$1$")
    if [ $1 != "$MODULE" ]; then
      echo "Error: $1 PHP module is not installed." >&2
      exit 1
    fi
}

doesPhpMatchVersion() {
    VERSION=$(php -v|grep -i "PHP $1")
    if [ -z "$VERSION" ]; then
      echo "Error: PHP version $1 is not found." >&2
      exit 1
    fi
}

itShouldDisableSessionUploadProgress() {
  php -r 'exit(ini_get("session.upload_progress.enabled") ? 1 : 0);'
  if [ $? -ne 0 ]; then
    echo "Error: session.upload_progress.enabled is not Off." >&2
    exit 1
  fi
}

itShouldDisableFatalErrorBacktraces() {
  php -r 'exit(get_cfg_var("fatal_error_backtraces") === "0" && !ini_get("fatal_error_backtraces") ? 0 : 1);'
  if [ $? -ne 0 ]; then
    echo "Error: fatal_error_backtraces is not Off." >&2
    exit 1
  fi
}

itShouldToggleModulesWithPhpenmodAndPhpdismod() {
  phpdismod decimal
  if php -m | grep -q -e "^decimal$"; then
    echo "Error: phpdismod failed to disable decimal." >&2
    exit 1
  fi

  phpenmod decimal
  if ! php -m | grep -q -e "^decimal$"; then
    echo "Error: phpenmod failed to re-enable decimal." >&2
    exit 1
  fi
}

itShouldSetUnlimitedCliMemoryLimit() {
  php -r 'exit(ini_get("memory_limit") === "-1" ? 0 : 1);'
  if [ $? -ne 0 ]; then
    echo "Error: CLI memory_limit is not -1." >&2
    exit 1
  fi
}

itShouldCheckThatAllInstalledSoftwareExists
itShouldCheckThatAllPhpModulesExists
itShouldMatchTheDesiredVersionOfPhp
itShouldSetUnlimitedCliMemoryLimit
itShouldDisableSessionUploadProgress
itShouldDisableFatalErrorBacktraces
itShouldToggleModulesWithPhpenmodAndPhpdismod
