cd $PECL_SRC_DIR
wget-retry http://www.libxl.com/download/libxl-lin-${LIBRARY_XL_VERSION}.tar.gz
tar -zxv -f libxl-lin-${LIBRARY_XL_VERSION}.tar.gz
cp libxl-${LIBRARY_XL_VERSION}.0/lib64/libxl.so /usr/lib/libxl.so
mkdir -p /usr/include/libxl_c/
cp libxl-${LIBRARY_XL_VERSION}.0/include_c/* /usr/include/libxl_c/
#git clone https://github.com/iliaal/php_excel.git -b php7 excel-${EXTENSION_EXCEL_VERSION}
wget-retry https://github.com/iliaal/php_excel/releases/download/Excel-${EXTENSION_EXCEL_VERSION}-PHP7/excel-${EXTENSION_EXCEL_VERSION}-php7.tgz
tar zxvf excel-${EXTENSION_EXCEL_VERSION}-php7.tgz
ext-pcl excel-${EXTENSION_EXCEL_VERSION} --with-libxl-incdir=/usr/include/libxl_c/

