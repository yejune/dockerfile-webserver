cd $PECL_SRC_DIR

ext-lib libmemcached-dev

git clone https://github.com/php-memcached-dev/php-memcached memcached-${EXTENSION_MEMCACHED_VERSION}

ext-pcl memcached-${EXTENSION_MEMCACHED_VERSION} \
        --enable-memcached-json \
        --enable-memcached-igbinary \
        --enable-memcached-msgpack \
