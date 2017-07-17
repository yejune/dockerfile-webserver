#!/bin/bash
set -e

# Install libmemcached

apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated \
        libmemcached-dev

git clone -b php7 https://github.com/php-memcached-dev/php-memcached ${lib}

pecl ${lib}
