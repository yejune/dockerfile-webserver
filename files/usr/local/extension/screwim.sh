cd $PECL_SRC_DIR
wget-retry https://github.com/OOPS-ORG-PHP/mod_screwim/archive/v${EXTENSION_SCREWIM_VERSION}.tar.gz
tar -zxvf v${EXTENSION_SCREWIM_VERSION}.tar.gz
mv mod_screwim-${EXTENSION_SCREWIM_VERSION} screwim-${EXTENSION_SCREWIM_VERSION}
ext-pcl screwim-${EXTENSION_SCREWIM_VERSION}
