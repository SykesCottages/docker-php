#!/bin/sh

itShouldCheckThatAllFilesExists() {
    doesFileExist /composer/composer-setup.php
    doesFileExist /etc/localtime
}

doesFileExist() {
    if [ ! -e "$1" ] && [ ! -L "$1" ]; then
      echo "Error: File $1 does not exist." >&2
      exit 1
    fi
}

itShouldCheckThatAllFilesExists
