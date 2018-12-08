cd $PECL_SRC_DIR

ext-lib libev-dev

wget-retry https://bitbucket.org/osmanov/pecl-ev/get/1.0.5.tar.gz
tar zxvf 1.0.5.tar.gz
mv osmanov-pecl-ev-426ee1e6e4fb ev-${EXTENSION_EV_VERSION}

ext-pcl ev-${EXTENSION_EV_VERSION}
