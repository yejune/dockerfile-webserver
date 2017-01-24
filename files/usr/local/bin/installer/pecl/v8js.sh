#!/bin/bash
set -e

# Install libv8

apt-add-repository ppa:pinepain/libv8-${LIBV8_VERSION} -y

apt-get update && apt-get install -y --no-install-recommends \
        libv8-${LIBV8_VERSION}-dev -y --allow-unauthenticated

mkdir -p /usr/src/pecl

cd /usr/src/pecl

git clone -b php7 https://github.com/phpv8/v8js ${lib}
