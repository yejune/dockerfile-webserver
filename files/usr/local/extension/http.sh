cd $PECL_SRC_DIR
ext-lib libidn2-dev libevent-dev libicu-dev
pecl install raphf
echo "extension=raphf.so" > ${PHP_CONF_DIR}/raphf.ini
pecl install propro
echo "extension=propro.so" > ${PHP_CONF_DIR}/propro.ini
printf "yes\n" | pecl install pecl_http-${EXTENSION_HTTP_VERSION}
echo "extension=http.so" > ${PHP_CONF_DIR}/http.ini
