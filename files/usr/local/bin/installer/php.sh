#!/bin/bash
set -e

arrIN=(${PHP_VERSION//\./ })
phpv="${arrIN[0]}.${arrIN[1]}"

if [ "$phpv" = "7.1" ]; then
  PHP7_KEY="A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E"
else
  PHP7_KEY="1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3"
fi

gpg --keyserver hkp://keys.gnupg.net --recv-keys ${PHP7_KEY}

mkdir -p ${PHP_INI_DIR}/conf.d

curl -SL "http://php.net/get/php-${PHP_VERSION}.tar.bz2/from/this/mirror" -o php.tar.bz2

curl -SL "http://php.net/get/php-${PHP_VERSION}.tar.bz2.asc/from/this/mirror" -o php.tar.bz2.asc

gpg --verify php.tar.bz2.asc

mkdir -p /usr/src/php

tar -xof php.tar.bz2 -C /usr/src/php --strip-components=1

rm php.tar.bz2*

pushd /usr/src/php

ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

./configure ${PHP_EXTRA_CONFIGURE_ARGS}

make -j"$(nproc)"

make install

make clean

cp /usr/src/php/php.ini-production ${PHP_INI_DIR}/php.ini

mkdir -p ${PHP_LOG_DIR} ${PHP_RUN_DIR}

popd

rm -rf /usr/src/php

# Install composer
wget http://getcomposer.org/composer.phar
chmod +x composer.phar
mv composer.phar /usr/local/bin/composer

# Install phpunit
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
mv phpunit.phar /usr/local/bin/phpunit
