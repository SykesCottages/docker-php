#!/bin/sh

PHP_VERSION=8.5

itShouldCheckThatAllInstalledSoftwareExists() {
    doesCommandExist php
    doesCommandExist composer
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

itShouldCheckThatAllInstalledSoftwareExists
itShouldCheckThatAllPhpModulesExists
itShouldMatchTheDesiredVersionOfPhp
itShouldDisableSessionUploadProgress
