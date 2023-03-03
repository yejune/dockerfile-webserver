cd ${PECL_SRC_DIR};

wget --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 --continue -c https://github.com/improved-php-library/http-message/archive/refs/tags/v${EXTENSION_HTTP_MESSAGE_VERSION}.tar.gz -O http_message-${EXTENSION_HTTP_MESSAGE_VERSION}.tar.gz

tar -zxvf http_message-${EXTENSION_HTTP_MESSAGE_VERSION}.tar.gz

mv http-message-${EXTENSION_HTTP_MESSAGE_VERSION} http_message-${EXTENSION_HTTP_MESSAGE_VERSION}

ext-pcl http_message-${EXTENSION_HTTP_MESSAGE_VERSION}
