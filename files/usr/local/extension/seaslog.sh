cd $PECL_SRC_DIR
wget-retry http://pecl.php.net/get/SeasLog-${EXTENSION_SEASLOG_VERSION}.tgz
tar -zxvf SeasLog-${EXTENSION_SEASLOG_VERSION}.tgz
mv SeasLog-${EXTENSION_SEASLOG_VERSION} seaslog-${EXTENSION_SEASLOG_VERSION}
ext-pcl seaslog-${EXTENSION_SEASLOG_VERSION}
