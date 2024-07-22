#!make

REPOGITORY_URL:=ap-northeast-2.ec2.archive.ubuntu.com

PHP81_GPGKEYS:=528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 39B641343D8C104B2B146DC3F9C39DC0B9698544 F1F692238FBC1666E5A5CCD4199F9DFEF6FFBAFD

PHP81_VERSION:=8.1.11
PHP81_SHA256:=3005198d7303f87ab31bc30695de76e8ad62783f806b6ab9744da59fe41cc5bd

# tar.xz
PHP82_VERSION:=8.2.4
PHP82_SHA256:=bc7bf4ca7ed0dd17647e3ea870b6f062fcb56b243bfdef3f59ff7f94e96176a8


PHP83_VERSION:=8.3.9
PHP83_SHA256:=bf4d7b8ea60a356064f88485278bd6f941a230ec16f0fc401574ce1445ad6c77


# LIBRARY_V8_VERSION:=7.5
# LIBRARY_XL_VERSION:=3.8.3
# LIBRARY_VIPS_VERSION:=8.10.0
# LIBRARY_RABBITMQ_VERSION:=0.8.0

LIBRARY_XLSWRITER_VERSION:=1.1.5
DOCKERIZE_VERSION:=0.7.0

EXTENSION_ZEPHIR_VERSION:=0.17.0
#EXTENSION_EXCEL_VERSION:=1.1.0
EXTENSION_EV_VERSION:=1.1.6RC1
EXTENSION_RUNKIT7_VERSION:=4.0.0a6
EXTENSION_CALLEE_VERSION:=0.0.0
EXTENSION_SCREWIM_VERSION:=1.0.5

# ocbc
# oci8
# pdo_dblib\

define DEFAULT_EXTENSIONS
    bcmath\
    bz2\
    calendar\
    ctype\
    curl\
    date\
    dba\
    dom\
    enchant\
    exif\
    fileinfo\
    filter\
    ftp\
    gd\
    gettext\
    gmp\
    hash\
    iconv\
    imap\
    intl\
    json\
    ldap\
    libxml\
    mbstring\
    mysqlnd\
    mysqli\
    opcache\
    openssl\
    pcntl\
    pcre\
    pdo\
    pdo_firebird\
    pdo_mysql\
    pdo_pgsql\
    pdo_sqlite\
    pgsql\
    phar\
    posix\
    pspell\
    readline\
    reflection\
    session\
    shmop\
    simplexml\
    snmp\
    soap\
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

# jsonnet
#
#
# couchbase

### php 8
#    v8js\
#    excel\
#    xmlrpc\
#    callee\
#    http\
#    pdo_sqlsrv\
#    wasm\
#    zookeeper\
#    event\
#    couchbase\
#    uopz\
#    simple_kafka\
#    rdkafka\
#    componere\
#    ddtrace\
#    excimer\
#    swoole\
#    fiber\
#    http_message\
#    solr\
#    apcu_bc\
#    grpc\
#    awscrt\
#    protobuf\
#    ssh2\
#    xhprof\
#    runkit7\
#    gearman\
#    memprof\
#    vld\
#    oauth\

#   awscrt\
#   protobuf\
#   ssh2\
#   grpc\
#   excimer\
#   phalcon\
#   swoole\
#   decimal\

define CUSTOM_EXTENSIONS
    msgpack\
    igbinary\
    memcached\
    xlswriter\
    xdebug\
    jsonpath\
    var_representation\
    eio\
    ev\
    uv\
    geospatial\
    seaslog\
    base58\
    zephir_parser\
    gearman\
    apcu\
    simdjson\
    bsdiff\
    yaml\
    imagick\
    mailparse\
    json_post\
    apfd\
    yaconf\
    uuid\
    vips\
    mongodb\
    psr\
    \
    redis\
    amqp
endef
