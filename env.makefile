#!make

REPOGITORY_URL:=ap-northeast-2.ec2.archive.ubuntu.com

PHP81_GPGKEYS:=528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 39B641343D8C104B2B146DC3F9C39DC0B9698544 F1F692238FBC1666E5A5CCD4199F9DFEF6FFBAFD

PHP81_VERSION:=8.1.11
PHP81_SHA256:=3005198d7303f87ab31bc30695de76e8ad62783f806b6ab9744da59fe41cc5bd

# tar.xz
PHP82_VERSION:=8.2.4
PHP82_SHA256:=bc7bf4ca7ed0dd17647e3ea870b6f062fcb56b243bfdef3f59ff7f94e96176a8


PHP83_VERSION:=8.3.12
PHP83_SHA256:=f774e28633e26fc8c5197f4dae58ec9e3ff87d1b4311cbc61ab05a7ad24bd131


PHP84_VERSION:=8.4.3
PHP84_SHA256:=5c42173cbde7d0add8249c2e8a0c19ae271f41d8c47d67d72bdf91a88dcc7e4b

RC_USER:=calvinb
ALPHA_USER:=krakjoe

# LIBRARY_V8_VERSION:=7.5
# LIBRARY_XL_VERSION:=3.8.3
# LIBRARY_VIPS_VERSION:=8.10.0
# LIBRARY_RABBITMQ_VERSION:=0.8.0

LIBRARY_XLSWRITER_VERSION:=1.1.5
DOCKERIZE_VERSION:=0.9.2

#EXTENSION_ZEPHIR_VERSION:=0.17.0
#EXTENSION_EXCEL_VERSION:=1.1.0
EXTENSION_EV_VERSION:=1.1.6RC1
EXTENSION_RUNKIT7_VERSION:=4.0.0a6
EXTENSION_CALLEE_VERSION:=0.0.0
EXTENSION_SCREWIM_VERSION:=1.0.5

# ocbc
# pdo_dblib\
# ldap\
# pdo_firebird\
# enchant\


define DEFAULT_EXTENSIONS
    bcmath\
    bz2\
    calendar\
    ctype\
    curl\
    date\
    dom\
    exif\
    fileinfo\
    filter\
    ftp\
    gd\
    gettext\
    gmp\
    hash\
    iconv\
    intl\
    json\
    libxml\
    mbstring\
    mysqlnd\
    opcache\
    openssl\
    pcntl\
    pcre\
    pdo\
    pdo_mysql\
    pdo_pgsql\
    pdo_sqlite\
    pgsql\
    phar\
    posix\
    readline\
    reflection\
    session\
    shmop\
    simplexml\
    sockets\
    sodium\
    spl\
    sqlite3\
    standard\
    sysvmsg\
    sysvsem\
    sysvshm\
    tidy\
    tokenizer\
    xml\
    xmlreader\
    xmlwriter\
    xsl\
    zip\
    zlib\
    ffi
endef

### php 8
#    apfd
#    awscrt
#    bsdiff
#    callee
#    componere
#    couchbase
#    ddtrace
#    decimal
#    excimer
#    excel
#    fiber
#    gearman
#    grpc
#    http
#    http_message
#    igbinary
#    imap
#    json_post
#    jsonpath
#    mailparse
#    memcached
#    memprof
#    msgpack
#    oci8
#    oauth
#    pdo_sqlsrv
#    phalcon
#    protobuf
#    pspell
#    rdkafka
#    runkit7
#    simple_kafka
#    simdjson
#    solr
#    ssh2
#    swoole
#    var_representation
#    v8js
#    vips
#    vld
#    uopz
#    uv
#    eio
#    event
#    ev
#    v8js
#    wasm
#    xhprof
#    xmlrpc
#    yaconf
#    zookeeper
#    zephir_parser
#    seaslog

define CUSTOM_EXTENSIONS
    xlswriter\
    imagick\
    mongodb\
    uuid\
    geospatial\
    base58\
    apcu\
    yaml\
    psr\
    \
    redis\
    amqp
endef
