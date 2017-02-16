#!/bin/bash
set -e

# Install libmemcached

mkdir -p /usr/src/pecl

cd /usr/src/pecl

wget https://launchpad.net/libmemcached/1.0/${LIBMEMCACHED_VERSION}/+download/libmemcached-${LIBMEMCACHED_VERSION}.tar.gz

tar xzf libmemcached-${LIBMEMCACHED_VERSION}.tar.gz

cd libmemcached-${LIBMEMCACHED_VERSION}

./configure --enable-sasl

make -j"$(nproc)"

make install

make clean

# git clone -b php7 https://github.com/php-memcached-dev/php-memcached ${lib}

pecl ${lib}
