cd $PECL_SRC_DIR

git clone https://github.com/wasmerio/wasmer-php
cd wasmer-php/ext
phpize
./configure --enable-wasmer
make
make test
make install

# export WASMER_DIR="/usr/wasmer"
# export WASMER_CACHE_DIR="/tmp/wasmer/cache"
# export PATH="$WASMER_DIR/bin:$WASMER_DIR/globals/wapm_packages/.bin:$PATH"


# cd $PECL_SRC_DIR

# export WASMER_DIR="/usr/wasmer"
# export WASMER_CACHE_DIR="/tmp/wasmer/cache"
# export PATH="$WASMER_DIR/bin:$WASMER_DIR/globals/wapm_packages/.bin:$PATH"

# curl https://get.wasmer.io -sSfL | sh


# git clone https://github.com/wasmerio/wasmer-php


# #pecl install -B wasm

# export CXX="gcc"
# export EXTENSION=$PECL_SRC_DIR/wasmer-php/ext

# cd $EXTENSION
# PHP_PREFIX=$(php-config --prefix)
# PHP_PREFIX_BIN=$PHP_PREFIX/bin
# $PHP_PREFIX_BIN/phpize --clean
# $PHP_PREFIX_BIN/phpize

# ./configure --with-php-config=$PHP_PREFIX_BIN/php-config

# make install-modules

# # mv $EXTENSION/libwasmer_runtime_c_api.so /usr/lib/libwasmer_runtime_c_api.so

echo "extension=wasm.so" > /etc/php/conf.d/wasm.ini;
