cd ${PECL_SRC_DIR};

git clone git://github.com/phalcon/php-zephir-parser.git;
cd ${PECL_SRC_DIR}/php-zephir-parser;
phpize;
./configure;
make;
make install;
echo "extension=zephir_parser.so" > /etc/php/conf.d/zephir_parser.ini;

cd ${USR_LIB_DIR};
git clone https://github.com/phalcon/zephir;
cd ${USR_LIB_DIR}/zephir;
composer install;

echo '#!/bin/bash
${USR_LIB_DIR}/zephir/zephir $@
' > ${USR_LOCAL_BIN_DIR}/zephir
chmod a+rx ${USR_LOCAL_BIN_DIR}/zephir
