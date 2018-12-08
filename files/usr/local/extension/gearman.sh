cd $PECL_SRC_DIR
ext-lib libevent-dev libgearman-dev
wget-retry https://github.com/wcgallego/pecl-gearman/archive/gearman-${EXTENSION_GEARMAN_VERSION}.tar.gz
tar -zxvf gearman-${EXTENSION_GEARMAN_VERSION}.tar.gz
mv pecl-gearman-gearman-${EXTENSION_GEARMAN_VERSION} gearman-${EXTENSION_GEARMAN_VERSION}
ext-pcl gearman-${EXTENSION_GEARMAN_VERSION}
rm -rf gearman-${EXTENSION_GEARMAN_VERSION}.tar.gz
