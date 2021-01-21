FROM yejune/webserver:focal-8.0.1-base
LABEL maintainer="k@yejune.com"

ENV DEBIAN_FRONTEND noninteractive

ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

ARG REPOGITORY_URL="archive.ubuntu.com"

ARG BUILD_EXTENSIONS

ARG EXTENSION_PHALCON_VERSION=4.0.4
ARG EXTENSION_SWOOLE_VERSION=4.6.1
ARG EXTENSION_UUID_VERSION=1.1.0
ARG EXTENSION_APFD_VERSION=1.0.2
ARG EXTENSION_JSONPOST_VERSION=1.0.2
ARG EXTENSION_YAML_VERSION=2.2.0
ARG EXTENSION_JSONNET_VERSION=1.3.1
ARG EXTENSION_PROTOBUF_VERSION=3.14.0RC2
ARG EXTENSION_IGBINARY_VERSION=3.2.2RC1
ARG EXTENSION_MSGPACK_VERSION=2.1.2
ARG EXTENSION_MAILPARSE_VERSION=3.1.1
ARG EXTENSION_BASE58_VERSION=1.0.2
ARG EXTENSION_APCU_VERSION=5.1.18
ARG EXTENSION_MEMCACHED_VERSION=3.1.5
ARG EXTENSION_REDIS_VERSION=5.3.2
ARG EXTENSION_MONGODB_VERSION=1.9.0
ARG EXTENSION_RDKAFKA_VERSION=5.0.0
ARG EXTENSION_COUCHBASE_VERSION=3.1.0
ARG EXTENSION_CASSANDRA_VERSION=1.3.2
ARG EXTENSION_AMQP_VERSION=1.10.2
ARG EXTENSION_GEARMAN_VERSION=2.1.0
ARG EXTENSION_SODIUM_VERSION=2.0.23
ARG EXTENSION_MCRYPT_VERSION=1.0.3
ARG EXTENSION_SCREWIM_VERSION=1.0.2
ARG EXTENSION_EV_VERSION=1.0.9
ARG EXTENSION_UV_VERSION=0.2.4
ARG EXTENSION_EIO_VERSION=2.0.4
ARG EXTENSION_EVENT_VERSION=3.0.2
ARG EXTENSION_MEMPROF_VERSION=2.1.2
ARG EXTENSION_HTTP_VERSION=4.0.0
ARG EXTENSION_CALLEE_VERSION=0.0.0
ARG EXTENSION_DECIMAL_VERSION=2.0.0
ARG EXTENSION_IMAGICK_VERSION=3.4.4
ARG EXTENSION_VIPS_VERSION=1.0.12
ARG EXTENSION_SSH2_VERSION=1.2
ARG EXTENSION_SQLSRV_VERSION=5.8.1
ARG EXTENSION_V8JS_VERSION=2.1.2
ARG EXTENSION_V8_VERSION=0.2.2
ARG EXTENSION_OAUTH_VERSION=2.0.7
ARG EXTENSION_EXCEL_VERSION=1.0.2
ARG EXTENSION_XLSWRITER_VERSION=1.3.7
ARG EXTENSION_XDEBUG_VERSION=3.0.1
ARG EXTENSION_SEASLOG_VERSION=2.2.0
ARG EXTENSION_COMPONERE_VERSION=3.1.2
ARG EXTENSION_RUNKIT7_VERSION=4.0.0a2
ARG EXTENSION_VLD_VERSION=0.17.0
ARG EXTENSION_DATADOG_TRACE_VERSION=0.54.0
ARG EXTENSION_GRPC_VERSION=1.35.0
ARG EXTENSION_PSR_VERSION=1.0.0
ARG EXTENSION_YACONF_VERSION=1.1.0
ARG EXTENSION_HTTP_MESSAGE_VERSION=0.2.2
ARG EXTENSION_WASM_VERSION=0.5.0
ARG DOCKERIZE_VERSION=0.6.1
ARG LIBRARY_XL_VERSION=3.8.3
ARG LIBRARY_XLSWRITER_VERSION=0.9.9
ARG LIBRARY_VIPS_VERSION=8.10.0
ARG LIBRARY_V8_VERSION=7.5

SHELL ["/bin/bash", "-c"]


RUN if [ "archive.ubuntu.com" != "${REPOGITORY_URL}" ]; then \
        sed -i "s/:\/\/${REPOGITORY_URL}/:\/\/archive.ubuntu.com/g" /etc/apt/sources.list; \
        sed -i "s/:\/\/${REPOGITORY_URL}/:\/\/security.ubuntu.com/g" /etc/apt/sources.list; \
    fi

ENV PHP_INI_DIR=/etc/php \
    PHP_CONF_DIR=/etc/php/conf.d \
    PHP_RUN_DIR=/run/php \
    PHP_LOG_DIR=/var/log/php \
    PHP_DATA_DIR=/var/lib/php \
    PHP_SRC_DIR=/usr/src/php \
    PECL_SRC_DIR=/usr/src/pecl \
    SRC_DIR=/usr/src \
    USR_LOCAL_BIN_DIR=/usr/local/bin \
    USR_LIB_DIR=/usr/lib

ENV FULL_EXTENSIONS="\
    psr\
    phalcon\
    \
    uuid\
    jsonnet\
    protobuf\
    igbinary\
    msgpack\
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
"

COPY files/ /

RUN set -xe; \
    source /init.sh; \
    \
    # savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get upgrade -y; \
    \
    DEPS=""; \
    \
    DEV_DEPS="pkg-config autoconf dpkg-dev file g++ gcc make re2c bison software-properties-common"; \
    \
    LIB_DEPS=" \
    "; \
    \
    mkdir -p "${PHP_CONF_DIR}"; \
    mkdir -p "${PHP_LOG_DIR}"; \
    mkdir -p "${SRC_DIR}"; \
    mkdir -p "${PECL_SRC_DIR}"; \
    mkdir -p "${PHP_SRC_DIR}"; \
    mkdir -p "${PHP_INI_DIR}/"; \
    mkdir -p "${PHP_INI_DIR}/php-fpm.d/"; \
    cd "${SRC_DIR}"; \
    \
    ADD_DEPS=' \
        lsb-release \
    '; \
    if ! command -v gpg > /dev/null; then \
        ADD_DEPS="${ADD_DEPS} \
            dirmngr \
            gnupg2 \
        "; \
    fi; \
    apt-get install --no-install-recommends --no-install-suggests -y ${DEPS} ${ADD_DEPS} ${DEV_DEPS} ${LIB_DEPS}; \
    \
    \
    BUILD_ARCH="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    PHP_EXTENSION_DIR=$(php-config --extension-dir); \
    \
    if [ ! -z "${BUILD_EXTENSIONS}" ]; then \
        BUILD_PHP_EXTENSIONS=( $BUILD_EXTENSIONS ); \
    else \
        BUILD_PHP_EXTENSIONS=( $FULL_EXTENSIONS ); \
    fi; \
    \
    \
    # src extension install
    for extension in "${BUILD_PHP_EXTENSIONS[@]}"; do \
        echo $extension; \
        cd $PECL_SRC_DIR; \
        php -r "echo extension_loaded('${extension}');"; \
        if [ -f "/usr/local/script/${extension}.sh" ]; then \
            source "/usr/local/script/${extension}.sh"; \
        else \
            if [ -f "/usr/local/extension/${extension}.sh" ]; then \
                source "/usr/local/extension/${extension}.sh"; \
            else \
                ext-src $extension; \
            fi; \
        fi; \
    done; \
    \
    \
    # clean
    rm -rf /init.sh; \
    { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; }; \
    apt-get clean; \
    apt-get purge --yes --auto-remove ${DEV_DEPS} ${ADD_DEPS}; \
    rm -rf $SRC_DIR/*; \
    rm -rf $PECL_SRC_DIR/*; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    php -v; \
    php -m;

RUN chown -Rf www-data:www-data /var/www

WORKDIR /var/www

EXPOSE 80 443

STOPSIGNAL SIGTERM

RUN chmod +x /run.sh

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD wget -qO- localhost/healthcheck.php || exit 1

ENTRYPOINT ["/run.sh"]
