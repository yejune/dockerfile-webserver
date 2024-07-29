#!make

REPOGITORY_URL:=ap-northeast-2.ec2.archive.ubuntu.com

PHP83_VERSION:=8.3.9
PHP83_SHA256:=bf4d7b8ea60a356064f88485278bd6f941a230ec16f0fc401574ce1445ad6c77


PHP84_VERSION:=8.4.0
PHP84_SHA256:=bf4d7b8ea60a356064f88485278bd6f941a230ec16f0fc401574ce1445ad6c77


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

#    ocbc
#    oci8
#    pdo_dblib\
#    pdo_firebird\
#    snmp\
#    ldap\
#    mysqli\
#    soap\
#    dba\
#    imap\

define DEFAULT_EXTENSIONS
    bcmath\
    bz2\
    calendar\
    ctype\
    curl\
    date\
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
    pspell\
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

#    awscrt\
#    protobuf\
#    ssh2\
#    grpc\
#    excimer\
#    phalcon\
#    swoole\
#    decimal\
#    memcached\
#    msgpack\
#    igbinary\
#    xdebug\
#    var_representation\
#    eio\
#    ev\
#    uv\
#    yaconf\
#    json_post\
#    jsonpath\
#    gearman\
#    simdjson\
#    bsdiff\
#    apfd\
#    mailparse\

define CUSTOM_EXTENSIONS
    vips\
    imagick\
    mongodb\
    uuid\
    xlswriter\
    geospatial\
    seaslog\
    base58\
    zephir_parser\
    apcu\
    yaml\
    psr\
    \
    redis\
    amqp
endef
