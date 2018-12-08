cd $PECL_SRC_DIR
ext-lib libmpdec-dev
wget-retry https://github.com/php-decimal/ext-decimal/archive/v${EXTENSION_DECIMAL_VERSION}.tar.gz
tar -zxvf v${EXTENSION_DECIMAL_VERSION}.tar.gz
mv ext-decimal-${EXTENSION_DECIMAL_VERSION} decimal-${EXTENSION_DECIMAL_VERSION}
ext-pcl decimal-${EXTENSION_DECIMAL_VERSION}
