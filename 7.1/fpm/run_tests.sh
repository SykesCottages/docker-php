#!/bin/sh

PHP_VERSION=7.1

itShouldCheckThatAllInstalledSoftwareExists() {
    doesCommandExist php-fpm
}

itShouldCheckThatAllPhpFpmModulesExists() {
  doesPhpFpmModuleExist bcmath
  doesPhpFpmModuleExist curl
  doesPhpFpmModuleExist intl
  doesPhpFpmModuleExist json
  doesPhpFpmModuleExist mbstring
  doesPhpFpmModuleExist mysqli
  doesPhpFpmModuleExist soap
  doesPhpFpmModuleExist uopz
  doesPhpFpmModuleExist xml
  doesPhpFpmModuleExist zip
}

itShouldMatchTheDesiredVersionOfPhpFpm() {
  doesPhpFpmMatchVersion $PHP_VERSION
}

doesCommandExist() {
    if ! [ -x "$(command -v $1)" ]; then
      echo "Error: $1 is not installed." >&2
      exit 1
    fi
}

doesPhpFpmModuleExist() {
    MODULE=$(php -m|grep -e "^$1$")
    if [ $1 != "$MODULE" ]; then
      echo "Error: $1 PHP module is not installed." >&2
      exit 1
    fi
}

doesPhpFpmMatchVersion() {
    VERSION=$(php -v|grep -i "PHP $1")
    if [ -z "$VERSION" ]; then
      echo "Error: PHP version $1 is not found." >&2
      exit 1
    fi
}

itShouldRunPhpFpmTestsSuccessfully() {
    php /tmp/test.php
    if [ $? -ne 0 ]; then
        echo "Error: PHP test script failed." >&2
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

itShouldCheckThatAllInstalledSoftwareExists
itShouldCheckThatAllPhpFpmModulesExists
itShouldMatchTheDesiredVersionOfPhpFpm
itShouldRunPhpFpmTestsSuccessfully
itShouldDisableSessionUploadProgress

echo "All tests passed successfully."
