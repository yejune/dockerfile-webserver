#!make

REPOGITORY_URL:=ap-northeast-2.ec2.archive.ubuntu.com

PHP71_GPGKEYS:=A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E 1729F83938DA44E27BA0F4D3DBDB397470D12172

PHP72_GPGKEYS:=1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F

PHP73_GPGKEYS:=CBAF69F173A0FEA4B537F470D66C9593118BCCB6 F38252826ACD957EF380D39F2F7956BC5DA04B5D

PHP74_GPGKEYS:=42670A7FE4D0441C8E4632349E4FDC074A4EF02D 5A52880781F755608BF815FC910DEB46F53EA312


PHP80_GPGKEYS:=BFDDD28642824F8118EF77909B67A5C12229118F 1729F83938DA44E27BA0F4D3DBDB397470D12172

# PHP71_VERSION:=7.1.15
# PHP71_SHA256:=0e17192fb43532e4ebaa190ecec9c7e59deea7dadb7dab67b19c2081a68bd817

# PHP72_VERSION:=7.2.3
# PHP72_SHA256:=b3a94f1b562f413c0b96f54bc309706d83b29ac65d9b172bc7ed9fb40a5e651f

# PHP71_VERSION:=7.1.16
# PHP71_SHA256:=a5d67e477248a3911af7ef85c8400c1ba8cd632184186fd31070b96714e669f1

# PHP72_VERSION:=7.2.4
# PHP72_SHA256:=7916b1bd148ddfd46d7f8f9a517d4b09cd8a8ad9248734e7c8dd91ef17057a88

# PHP71_VERSION:=7.1.17
# PHP71_SHA256:=1a784806866e06367f7a5c88775d239d6f30041c7ce65a8232d03a3d4de56d56

# PHP72_VERSION:=7.2.5
# PHP72_SHA256:=af70a33b3f7a51510467199b39af151333fbbe4cc21923bad9c7cf64268cddb2

# PHP71_VERSION:=7.1.18
# PHP71_SHA256:=8bd91cea072ea5b368cc9b4533a1a683eb426abdacbf024bb6ffa9b799cd3b01

# PHP72_VERSION:=7.2.6
# PHP72_SHA256:=1f004e049788a3effc89ef417f06a6cf704c95ae2a718b2175185f2983381ae7

# PHP71_VERSION:=7.1.20
# PHP71_SHA256:=cd7d1006201459d43fae0790cce4eb3451add5c87f4cadb13b228d4c179b850c

# PHP72_VERSION:=7.2.8
# PHP72_SHA256:=53ba0708be8a7db44256e3ae9fcecc91b811e5b5119e6080c951ffe7910ffb0f

# PHP71_VERSION:=7.1.21
# PHP71_SHA256:=d4da6dc69d3fe1e6b2b80f16b262f391037bfeb21213c966e026bd45d7ca2813

# PHP72_VERSION:=7.2.9
# PHP72_SHA256:=3585c1222e00494efee4f5a65a8e03a1e6eca3dfb834814236ee7f02c5248ae0

# PHP73_VERSION:=7.3.0beta3
# PHP73_SHA256:=062111b400939d26f3a6ec41925b52b93feb1a5e70e3ccade12496cea9fb190f

# PHP71_VERSION:=7.1.22
# PHP71_SHA256:=9194c9b3a592d8376fde837dde711ec01ee26f8607fc2884047ef6f7c089b15d

# PHP71_VERSION:=7.1.23
# PHP71_SHA256:=227a3c76133c3dc1cec937989456cbd89ed00e68e7260c651900dbe1f5b798bc

# PHP72_VERSION:=7.2.10
# PHP72_SHA256:=01c2154a3a8e3c0818acbdbc1a956832c828a0380ce6d1d14fea495ea21804f0

# PHP72_VERSION:=7.2.11
# PHP72_SHA256:=da1a705c0bc46410e330fc6baa967666c8cd2985378fb9707c01a8e33b01d985


# PHP73_VERSION:=7.3.0RC1
# PHP73_SHA256:=f6af9e4e2376f1aadee8d1b4b7a60c5080bf53fe8816e141c78d4f72c93c5075

# PHP73_VERSION:=7.3.0RC2
# PHP73_SHA256:=f52692cb4f5144365a72c6ff698101035a27bceebf2d5a307ad82dd43ee9d751

# PHP73_VERSION:=7.3.0RC4
# PHP73_SHA256:=11582176003e0e8ca06dbdebab0921d539cab2ad795c0d90f146977859e21c26

# PHP71_VERSION:=7.1.24
# PHP71_SHA256:=e70dcec0ae28b6bc308b78972ec15aa850808819cc765f505aa51e5a7e2fa5d7

# PHP72_VERSION:=7.2.12
# PHP72_SHA256:=989c04cc879ee71a5e1131db867f3c5102f1f7565f805e2bb8bde33f93147fe1

# PHP73_VERSION:=7.3.0RC6
# PHP73_SHA256:=8120b5830e24d5fabc96da693ab924852e6c2a95829ad994d6a5107c69787848

# PHP73_VERSION:=7.3.0
# PHP73_SHA256:=7d195cad55af8b288c3919c67023a14ff870a73e3acc2165a6d17a4850a560b5

# PHP73_VERSION:=7.3.1
# PHP73_SHA256:=cfe93e40be0350cd53c4a579f52fe5d8faf9c6db047f650a4566a2276bf33362

# PHP73_VERSION:=7.3.2
# PHP73_SHA256:=010b868b4456644ae227d05ad236c8b0a1f57dc6320e7e5ad75e86c5baf0a9a8

# PHP73_VERSION:=7.3.3
# PHP73_SHA256:=6bb03e79a183d0cb059a6d117bbb2e0679cab667fb713a13c6a16f56bebab9b3

# PHP73_VERSION:=7.3.4
# PHP73_SHA256:=6fe79fa1f8655f98ef6708cde8751299796d6c1e225081011f4104625b923b83

# PHP73_VERSION:=7.3.5
# PHP73_SHA256:=e1011838a46fd4a195c8453b333916622d7ff5bce4aca2d9d99afac142db2472

# PHP73_VERSION:=7.3.6
# PHP73_SHA256:=fefc8967daa30ebc375b2ab2857f97da94ca81921b722ddac86b29e15c54a164

# PHP72_VERSION:=7.2.13
# PHP72_SHA256:=14b0429abdb46b65c843e5882c9a8c46b31dfbf279c747293b8ab950c2644a4b

# PHP72_VERSION:=7.2.14
# PHP72_SHA256:=ee3f1cc102b073578a3c53ba4420a76da3d9f0c981c02b1664ae741ca65af84f

PHP72_VERSION:=7.2.15
PHP72_SHA256:=75e90012faef700dffb29311f3d24fa25f1a5e0f70254a9b8d5c794e25e938ce

# PHP71_VERSION:=7.1.25
# PHP71_SHA256:=0fd8dad1903cd0b2d615a1fe4209f99e53b7292403c8ffa1919c0f4dd1eada88

PHP71_VERSION:=7.1.26
PHP71_SHA256:=10b7ae634c12852fae52a22dc2262e5f12418ad59fd20da2d00d71a212235d31

# PHP73_VERSION:=7.3.7
# PHP73_SHA256:=ba067200ba649956b3a92ec8b71a6ed8ce8a099921212443c1bcf3260a29274c

# PHP73_VERSION:=7.3.8
# PHP73_SHA256:=f6046b2ae625d8c04310bda0737ac660dc5563a8e04e8a46c1ee24ea414ad5a5

# PHP73_VERSION:=7.3.9
# PHP73_SHA256:=4007f24a39822bef2805b75c625551d30be9eeed329d52eb0838fa5c1b91c1fd

# PHP73_VERSION:=7.3.10
# PHP73_SHA256:=42f00a15419e05771734b7159c8d39d639b8a5a6770413adfa2615f6f923d906

PHP73_VERSION:=7.3.11
PHP73_SHA256:=657cf6464bac28e9490c59c07a2cf7bb76c200f09cfadf6e44ea64e95fa01021

# PHP74_VERSION:=7.4.0RC2
# PHP74_SHA256:=90483cc337f713d958018d9188b26852949470ca700cc0b7c80877d3363512c3

# PHP74_VERSION:=7.4.0RC3
# PHP74_SHA256:=0f9aa7a1b42bd9c43895e676fc9383b8392156001e34735e0911c72ae8e81d4a

# PHP74_VERSION:=7.4.0RC4
# PHP74_SHA256:=6fcce4c914825fbf5510b448df1485469da621d419d798ef77168808ce0bd10c

# PHP74_VERSION:=7.4.0RC6
# PHP74_SHA256:=6873a51f56a2c6bba192ff38e33158578c2a4380c2e2f0758949ebf55cc915a7

# PHP74_VERSION:=7.4.0
# PHP74_SHA256:=9bb751b20e5d6cc1ea9b1ebf23ef2d5f07f99b2d9cc417bf1d70c04f8b20ec42

# PHP74_VERSION:=7.4.1
# PHP74_SHA256:=561bb866bdd509094be00f4ece7c3543ec971c4d878645ee81437e291cffc762


# PHP74_VERSION:=7.4.2
# PHP74_SHA256:=98284deac017da0d426117ecae7599a1f1bf62ae3911e8bc16c4403a8f4bdf13

# PHP74_VERSION:=7.4.3
# PHP74_SHA256:=cf1f856d877c268124ded1ede40c9fb6142b125fdaafdc54f855120b8bc6982a


PHP74_VERSION:=7.4.10
PHP74_SHA256:=c2d90b00b14284588a787b100dee54c2400e7db995b457864d66f00ad64fb010


PHP80_VERSION:=8.0.1
PHP80_SHA256:=208b3330af881b44a6a8c6858d569c72db78dab97810332978cc65206b0ec2dc


LIBRARY_V8_VERSION:=7.5
LIBRARY_XL_VERSION:=3.8.3
LIBRARY_XLSWRITER_VERSION:=0.9.9
LIBRARY_VIPS_VERSION:=8.10.0
LIBRARY_RABBITMQ_VERSION:=0.8.0

EXTENSION_PHALCON_VERSION:=4.0.4
EXTENSION_SWOOLE_VERSION:=4.6.1
EXTENSION_UUID_VERSION:=1.1.0
EXTENSION_APFD_VERSION:=1.0.2
EXTENSION_JSONPOST_VERSION:=1.0.2
EXTENSION_YAML_VERSION:=2.2.0
EXTENSION_JSONNET_VERSION:=1.3.1
EXTENSION_PROTOBUF_VERSION:=3.14.0RC2
EXTENSION_IGBINARY_VERSION:=3.2.2RC1
EXTENSION_MSGPACK_VERSION:=2.1.2
EXTENSION_MAILPARSE_VERSION:=3.1.1
EXTENSION_BASE58_VERSION:=1.0.2
EXTENSION_APCU_VERSION:=5.1.18
EXTENSION_MEMCACHED_VERSION:=3.1.5
EXTENSION_REDIS_VERSION:=5.3.2
EXTENSION_MONGODB_VERSION:=1.9.0
EXTENSION_RDKAFKA_VERSION:=5.0.0
EXTENSION_COUCHBASE_VERSION:=3.1.0
EXTENSION_CASSANDRA_VERSION:=2.4.6
EXTENSION_AMQP_VERSION:=1.10.2
EXTENSION_GEARMAN_VERSION:=2.1.0
EXTENSION_SODIUM_VERSION:=2.0.23
EXTENSION_MCRYPT_VERSION:=1.0.3
EXTENSION_SCREWIM_VERSION:=1.0.2
EXTENSION_EV_VERSION:=1.0.9
EXTENSION_UV_VERSION:=0.2.4
EXTENSION_EIO_VERSION:=2.0.4
EXTENSION_EVENT_VERSION:=3.0.2
EXTENSION_MEMPROF_VERSION:=2.1.2
EXTENSION_HTTP_VERSION:=4.0.0
EXTENSION_CALLEE_VERSION:=0.0.0
EXTENSION_DECIMAL_VERSION:=2.0.0
EXTENSION_IMAGICK_VERSION:=3.4.4
EXTENSION_VIPS_VERSION:=1.0.12
EXTENSION_SSH2_VERSION:=1.2
EXTENSION_SQLSRV_VERSION:=5.8.1
EXTENSION_V8JS_VERSION:=2.1.2
EXTENSION_V8_VERSION:=0.2.2
EXTENSION_OAUTH_VERSION:=2.0.7
EXTENSION_EXCEL_VERSION:=1.0.2
EXTENSION_XLSWRITER_VERSION:=1.3.7
EXTENSION_XDEBUG_VERSION:=3.0.1
EXTENSION_SEASLOG_VERSION:=2.2.0
EXTENSION_COMPONERE_VERSION:=3.1.2
EXTENSION_RUNKIT7_VERSION:=4.0.0a2
EXTENSION_VLD_VERSION:=0.17.0
EXTENSION_DATADOG_TRACE_VERSION:=0.54.0
EXTENSION_GRPC_VERSION:=1.35.0
EXTENSION_PSR_VERSION:=1.0.0
EXTENSION_YACONF_VERSION:=1.1.0
EXTENSION_HTTP_MESSAGE_VERSION:=0.2.2
DOCKERIZE_VERSION:=0.6.1


# ocbc
# oci8
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
    mysqli\
    mysqlnd\
    opcache\
    openssl\
    pcntl\
    pcre\
    pdo\
    pdo_dblib\
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


# recode
# wddx
# ocbc
# oci8
# interbase
define DEFAULT_EXTENSIONS2
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
    interbase\
    intl\
    json\
    ldap\
    libxml\
    mbstring\
    mysqli\
    mysqlnd\
    opcache\
    openssl\
    pcntl\
    pcre\
    pdo\
    pdo_dblib\
    pdo_firebird\
    pdo_mysql\
    pdo_pgsql\
    pdo_sqlite\
    pgsql\
    phar\
    posix\
    pspell\
    readline\
    recode\
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
    wddx\
    xml\
    xmlreader\
    xmlwriter\
    xsl\
    zip\
    zlib
endef

# v8js
# msgpack
# vips
define FULL_EXTENSIONS
    apcu\
    psr\
    phalcon\
    \
    uuid\
    apfd\
    json_post\
    jsonnet\
    igbinary\
    msgpack\
    mailparse\
    base58\
    yaml\
    memcached\
    mongodb\
    redis\
    amqp\
    gearman\
    screwim\
    ev\
    uv\
    eio\
    event\
    \
    swoole\
    http\
    excel\
    xlswriter\
    callee\
    decimal\
    \
    \
    imagick\
    ssh2\
    \
    couchbase\
    cassandra\
    v8js\
    v8\
    \
    \
    memprof\
    seaslog\
    oauth\
    pdo_sqlsrv\
    componere\
    vld
endef

define CUSTOM_EXTENSIONS2
    ssh2\
    wasm\
    psr\
    http_message\
    v8js\
    datadog_trace\
    grpc\
    \
    apcu\
    \
    uuid\
    apfd\
    json_post\
    jsonnet\
    protobuf\
    igbinary\
    msgpack\
    mailparse\
    base58\
    yaml\
    memcached\
    mongodb\
    rdkafka\
    redis\
    amqp\
    gearman\
    ev\
    uv\
    eio\
    event\
    \
    http\
    excel\
    xlswriter\
    callee\
    decimal\
    \
    \
    imagick\
    \
    memprof\
    seaslog\
    oauth\
    \
    couchbase\
    componere\
    runkit7\
    vld\
    zephir
endef

# jsonnet
#
#
# couchbase

### php 8
#    v8js\
#    eio\
#    vld\
#    wasm\
#    excel\
#    decimal\
#    ssh2\
#    memprof\
#    xmlrpc\
#    callee\
#    protobuf\
#    event\
#    ev\
#    uv\
#    http\
#    couchbase\


define CUSTOM_EXTENSIONS
    grpc\
    seaslog\
    rdkafka\
    gearman\
    msgpack\
    swoole\
    mongodb\
    psr\
    imagick\
    \
    apcu\
    http_message\
    componere\
    redis\
    amqp\
    igbinary\
    memcached\
    mailparse\
    base58\
    yaml\
    json_post\
    apfd\
    xlswriter\
    yaconf\
    oauth\
    uuid\
    vips\
    datadog_trace\
    runkit7
endef


define CUSTOM_EXTENSIONS3
    v8js
endef
