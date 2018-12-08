ext-lib libsodium-dev
if [[ $PHP_VERSION == "7.1."* ]]; then
    cd $PECL_SRC_DIR
    wget-retry https://github.com/jedisct1/libsodium-php/archive/${EXTENSION_SODIUM_VERSION}.tar.gz
    tar -zxvf ${EXTENSION_SODIUM_VERSION}.tar.gz
    mv libsodium-php-${EXTENSION_SODIUM_VERSION} sodium-${EXTENSION_SODIUM_VERSION}
    ext-pcl sodium-${EXTENSION_SODIUM_VERSION}
else
    ext-src sodium
fi
