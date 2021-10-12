#!/bin/sh

VERSION=$1

/security/cvescan.sh --json > /tmp/cvescan.log
cat /tmp/cvescan.log | sed '/{/,$!d' > /cve-reports/$VERSION.json