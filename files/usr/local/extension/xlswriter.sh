cd $PECL_SRC_DIR
#git clone https://github.com/jmcnamara/libxlsxwriter.git


# wget-retry https://github.com/jmcnamara/libxlsxwriter/archive/refs/tags/v${LIBRARY_XLSWRITER_VERSION}.tar.gz
# tar zxvf v${LIBRARY_XLSWRITER_VERSION}.tar.gz
# mv libxlsxwriter-${LIBRARY_XLSWRITER_VERSION} libxlsxwriter

wget-retry https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_${LIBRARY_XLSWRITER_VERSION}.tar.gz
tar zxvf RELEASE_${LIBRARY_XLSWRITER_VERSION}.tar.gz
mv libxlsxwriter-RELEASE_${LIBRARY_XLSWRITER_VERSION} libxlsxwriter
cd libxlsxwriter
make clean
make
make install

printf "yes\n" | ext-pcl xlswriter-${EXTENSION_XLSWRITER_VERSION} --with-libxlsxwriter --enable-reader

# # ext-pcl xlswriter-${EXTENSION_XLSWRITER_VERSION}
# printf "yes\n" | pecl install xlswriter-${EXTENSION_XLSWRITER_VERSION}
# echo "extension=xlswriter.so" > ${PHP_CONF_DIR}/xlswriter.ini
