pecl install xdebug-${EXTENSION_XDEBUG_VERSION}
XDEBUG_INI="${PHP_CONF_DIR}/xdebug.ini"
echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > ${XDEBUG_INI}
echo "xdebug.remote_enable=on" >> ${XDEBUG_INI}
echo "xdebug.remote_autostart=on" >> ${XDEBUG_INI}
