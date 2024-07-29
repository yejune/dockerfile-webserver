cd $PECL_SRC_DIR

ext-lib libmemcached-dev

git clone https://github.com/php-memcached-dev/php-memcached memcached-${EXTENSION_MEMCACHED_VERSION}
ext-pcl memcached-${EXTENSION_MEMCACHED_VERSION} \
        --includedir=/usr/src/php \
        --enable-memcached-session \
        --enable-memcached-json \
        --enable-memcached-sasl \
        --enable-memcached-tls \
        --enable-memcached-igbinary \
        --enable-memcached-msgpack \

# ext-lib libsasl2-dev
# ext-lib sasl2-bin libsasl2-modules 

# git clone https://github.com/awslabs/aws-elasticache-cluster-client-libmemcached.git

# cd aws-elasticache-cluster-client-libmemcached

# touch configure.ac aclocal.m4 configure Makefile.am Makefile.in

# mkdir BUILD

# cd BUILD

# ../configure --with-pic --enable-sasl --enable-tls 

# make

# make install

# cd $PECL_SRC_DIR

# git clone -b php8.x https://github.com/awslabs/aws-elasticache-cluster-client-memcached-for-php memcached-${EXTENSION_MEMCACHED_VERSION}

# ext-pcl memcached-${EXTENSION_MEMCACHED_VERSION} \
#         --includedir=/usr/src/php \
#         --enable-memcached-session \
#         --enable-memcached-json \
#         --enable-memcached-sasl \
#         --enable-memcached-tls \
#         --enable-memcached-igbinary \
#         --enable-memcached-msgpack \

