cd $PECL_SRC_DIR
pecl install xhprof-${EXTENSION_XHPROF_VERSION}
XHPROF_INI="${PHP_CONF_DIR}/xhprof.ini"
echo "extension=$(find /usr/local/lib/php/extensions/ -name xhprof.so)" > ${XHPROF_INI}
echo "xhprof.output_dir = /tmp/xhprof" >> ${XHPROF_INI}
