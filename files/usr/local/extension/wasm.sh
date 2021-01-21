cd $PECL_SRC_DIR

export WASMER_DIR="/usr/wasmer"
export WASMER_CACHE_DIR="/tmp/wasmer/cache"
export PATH="$WASMER_DIR/bin:$WASMER_DIR/globals/wapm_packages/.bin:$PATH"

curl https://get.wasmer.io -sSfL | sh

wget-retry https://github.com/wasmerio/php-ext-wasm/archive/${EXTENSION_WASM_VERSION}.tar.gz

tar zxvf ${EXTENSION_WASM_VERSION}.tar.gz

rm -rf ${EXTENSION_WASM_VERSION}.tar.gz

#pecl install -B wasm

export CXX="gcc"
export EXTENSION=$PECL_SRC_DIR/wasmer-php-${EXTENSION_WASM_VERSION}/src

cd $EXTENSION
PHP_PREFIX=$(php-config --prefix)
PHP_PREFIX_BIN=$PHP_PREFIX/bin
$PHP_PREFIX_BIN/phpize --clean
$PHP_PREFIX_BIN/phpize

./configure --with-php-config=$PHP_PREFIX_BIN/php-config

/bin/bash $EXTENSION/libtool --mode=compile $CXX -I. -I$EXTENSION -DPHP_ATOM_INC -I$EXTENSION/include -I$EXTENSION/main -I$EXTENSION -I$PHP_PREFIX/include/php -I$PHP_PREFIX/include/php/main -I$PHP_PREFIX/include/php/TSRM -I$PHP_PREFIX/include/php/Zend -I$PHP_PREFIX/include/php/ext -I$PHP_PREFIX/include/php/ext/date/lib -DHAVE_CONFIG_H -c $EXTENSION/wasm.cc -o wasm.lo -fPIC

$CXX -I. -I$EXTENSION -DPHP_ATOM_INC -I$EXTENSION/include -I$EXTENSION/main -I$EXTENSION -I$PHP_PREFIX/include/php -I$PHP_PREFIX/include/php/main -I$PHP_PREFIX/include/php/TSRM -I$PHP_PREFIX/include/php/Zend -I$PHP_PREFIX/include/php/ext -I$PHP_PREFIX/include/php/ext/date/lib -DHAVE_CONFIG_H -c $EXTENSION/wasm.cc  -DPIC -o .libs/wasm.o -fPIC

/bin/bash $EXTENSION/libtool --mode=link cc -DPHP_ATOM_INC -I$EXTENSION/include -I$EXTENSION/main -I$EXTENSION -I$PHP_PREFIX/include/php -I$PHP_PREFIX/include/php/main -I$PHP_PREFIX/include/php/TSRM -I$PHP_PREFIX/include/php/Zend -I$PHP_PREFIX/include/php/ext -I$PHP_PREFIX/include/php/ext/date/lib  -DHAVE_CONFIG_H  -g -O2    -o wasm.la -export-dynamic -avoid-version -prefer-pic -module -rpath $EXTENSION/modules  wasm.lo -Wl,-rpath,$EXTENSION/. -L$EXTENSION/. -lwasmer_runtime_c_api -fPIC

cc -shared  .libs/wasm.o  -L$EXTENSION/. -lwasmer_runtime_c_api  -Wl,-rpath -Wl,$EXTENSION/. -Wl,-soname -Wl,wasm.so -o .libs/wasm.so -fPIC

make install-modules

mv $EXTENSION/libwasmer_runtime_c_api.so /usr/lib/libwasmer_runtime_c_api.so

echo "extension=wasm.so" > /etc/php/conf.d/wasm.ini;

php -m
