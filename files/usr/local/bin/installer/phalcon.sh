#!/bin/bash
set -e

mkdir -p /usr/src/pecl

pushd /usr/src/pecl

wget https://github.com/phalcon/cphalcon/archive/v${PHALCON_VER}.tar.gz

tar zxvf v${PHALCON_VER}.tar.gz

cd /usr/src/pecl/cphalcon-${PHALCON_VER}/build/php7/64bits

phpize

./configure CFLAGS="-O2 -g -fomit-frame-pointer -DPHALCON_RELEASE"

make

make install

echo "extension=phalcon.so" > ${PHP_INI_DIR}/conf.d/phalcon.ini

popd

rm -rf /usr/src/pecl