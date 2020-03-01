#!/bin/sh

itShouldCheckThatAllInstalledSoftwareExists() {
    doesCommandExist php
    doesCommandExist composer
}

itShouldCheckThatAllPhpModulesExists() {
  doesPhpModuleExist bcmath
  doesPhpModuleExist curl
  doesPhpModuleExist intl
  doesPhpModuleExist json
  doesPhpModuleExist mbstring
  doesPhpModuleExist mysqli
  doesPhpModuleExist soap
  doesPhpModuleExist xml
  doesPhpModuleExist zip
}

doesCommandExist() {
    if ! [ -x "$(command -v $1)" ]; then
      echo "Error: $1 is not installed." >&2
      exit 1
    fi
}

doesPhpModuleExist() {
    if [ $1 != "$(php -m|grep -e ^$1$)" ]; then
      echo "Error: $1 PHP module is not installed." >&2
      exit 1
    fi
}

itShouldCheckThatAllInstalledSoftwareExists
itShouldCheckThatAllPhpModulesExists
