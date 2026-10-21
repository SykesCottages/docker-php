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

itShouldCheckThatAllInstalledSoftwareExists
itShouldDisableSessionUploadProgress
