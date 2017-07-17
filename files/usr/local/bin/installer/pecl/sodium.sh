#!/bin/bash
set -e

#apt-get update && apt-get install -y --no-install-recommends \
#        libsodium-dev

mkdir -p /usr/src/pecl

cd /usr/src/pecl

# library

git clone https://github.com/jedisct1/libsodium --branch stable

pushd libsodium

./configure

make && make install

popd


# extension

pecl_download lib${lib_fullname}

pushd lib${lib_fullname}

phpize

./configure

make

make install

echo "extension=sodium.so" > $extension_ini/sodium.ini

popd
