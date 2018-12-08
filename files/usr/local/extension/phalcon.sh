cd $PECL_SRC_DIR
wget-retry https://github.com/phalcon/cphalcon/archive/v${EXTENSION_PHALCON_VERSION}.tar.gz
tar -zxvf v${EXTENSION_PHALCON_VERSION}.tar.gz
mv cphalcon-${EXTENSION_PHALCON_VERSION}/build/php7/64bits phalcon-${EXTENSION_PHALCON_VERSION}
PREV_PHP_CFLAGS="${PHP_CFLAGS}"
PHP_CFLAGS="${PHP_CFLAGS} -g -fomit-frame-pointer -DPHALCON_RELEASE"
ext-pcl phalcon-${EXTENSION_PHALCON_VERSION}
PHP_CFLAGS="${PREV_PHP_CFLAGS}"
