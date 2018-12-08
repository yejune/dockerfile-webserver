cd $PECL_SRC_DIR
wget-retry http://pecl.php.net/get/Jsonnet-${EXTENSION_JSONNET_VERSION}.tgz
tar -zxvf Jsonnet-${EXTENSION_JSONNET_VERSION}.tgz
mv Jsonnet-${EXTENSION_JSONNET_VERSION} jsonnet-${EXTENSION_JSONNET_VERSION}
ext-pcl jsonnet-${EXTENSION_JSONNET_VERSION}
