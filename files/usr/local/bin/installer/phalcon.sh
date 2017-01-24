#!/bin/bash
set -e

mkdir -p /usr/src/pecl

pushd /usr/src/pecl

wget https://github.com/phalcon/cphalcon/archive/v${PHALCON_VER}.tar.gz

tar zxvf v${PHALCON_VER}.tar.gz

cd /usr/src/pecl/cphalcon-${PHALCON_VER}/build

./install

echo "extension=phalcon.so" > ${PHP_INI_DIR}/conf.d/phalcon.ini

popd

rm -rf /usr/src/pecl