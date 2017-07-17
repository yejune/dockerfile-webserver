#!/bin/bash
set -e

#apt-get update && apt-get install -y --no-install-recommends \
#        libsodium-dev

mkdir -p /usr/src/pecl

cd /usr/src/pecl

git clone https://github.com/jedisct1/libsodium --branch stable

cd libsodium

./configure

make && make install

pecl ${lib}
