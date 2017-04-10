#!/bin/bash
set -e

PHP_VERSION='7.1.0'

IN="$PHP_VERSION"
arrIN=(${PHP_VERSION//\./ })
phpv="${arrIN[0]}.${arrIN[1]}"

if [ "$phpv" = "7.1" ]; then
  echo 7.1
else
  echo $phpv
fi