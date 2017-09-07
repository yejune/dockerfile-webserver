FROM ubuntu:16.04
MAINTAINER max

ENV DEBIAN_FRONTEND noninteractive

ARG BUILD_LOCALE
ARG BUILD_TYPE

SHELL ["/bin/bash", "-c"]

RUN if [ "ko" = "${BUILD_LOCALE}" ]; then \
        sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list; \
        sed -i 's/security.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list; \
    fi

ENV NGINX_VERSION 1.12.1
ENV NGINX_GPGKEY 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62

ENV PHP_VERSION 7.1.9
ENV PHP_GPGKEYS A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E
ENV PHP_SHA256="ec9ca348dd51f19a84dc5d33acfff1fba1f977300604bdac08ed46ae2c281e8c" PHP_MD5=""

ENV PHP_INI_DIR=/etc/php \
    PHP_RUN_DIR=/run/php \
    PHP_LOG_DIR=/var/log/php \
    PHP_DATA_DIR=/var/lib/php \
    PHP_SRC_DIR=/usr/src/php \
    PHP_CONF_DIR=/etc/php/conf.d \
    PECL_SRC_DIR=/usr/src/pecl \
    SRC_DIR=/usr/src

ENV DEPS \
        locales \
        tzdata \
        openssl \
        ca-certificates \
        wget \
        curl \
        ssh \
        git \
        apt-utils \
        apt-transport-https \
        xz-utils

ENV EXTENSIONS \
    bcmath bz2 calendar ctype dom gettext gmp hash iconv intl json pcntl pdo pdo_mysql posix session simplexml soap sockets xml xmlreader xmlwriter yaml apcu memcached redis uuid phalcon

ENV EXTEND_EXTENSIONS \
    dba enchant exif fileinfo gd pdo_pgsql pdo_sqlite phar pspell recode shmop snmp sqlite3 tidy tokenizer wddx xsl xmlrpc zip ev uv ssh2 sodium pdo_sqlsrv gearman amqp v8js v8

ENV DEV_DEPS \
        pkg-config \
        autoconf \
        dpkg-dev \
        file \
        g++ \
        gcc \
        make \
        re2c \
        bison \
        python-software-properties \
        software-properties-common

COPY files/ /

RUN set -xe; \
    apt-get update; \
    apt-get upgrade -y; \
    mkdir -p "${PHP_CONF_DIR}"; \
    mkdir -p "${PHP_LOG_DIR}"; \
    mkdir -p "${SRC_DIR}"; \
    cd "${SRC_DIR}"; \
    \
    ADD_DEPS=' \
    '; \
    if ! command -v gpg > /dev/null; then \
        ADD_DEPS="${ADD_DEPS} \
            dirmngr \
            gnupg2 \
        "; \
    fi; \
    apt-get install -y --no-install-recommends ${DEPS} ${ADD_DEPS}; \
    \
    # Install nginx
    NJS_VERSION="${NGINX_VERSION}.0.1.10-1~xenial"; \
    NGINX_VERSION="${NGINX_VERSION}-1~xenial"; \
    found=''; \
    for server in \
        ha.pool.sks-keyservers.net \
        hkp://keyserver.ubuntu.com:80 \
        hkp://p80.pool.sks-keyservers.net:80 \
        pgp.mit.edu \
    ; do \
        echo "Fetching GPG key ${NGINX_GPGKEY} from $server"; \
        apt-key adv --keyserver "${server}" --keyserver-options timeout=10 --recv-keys "${NGINX_GPGKEY}" && found=yes && break; \
    done; \
    test -z "$found" && echo >&2 "error: failed to fetch GPG key ${NGINX_GPGKEY}" && exit 1; \
    echo "deb http://nginx.org/packages/ubuntu/ xenial nginx" >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install --no-install-recommends --no-install-suggests -y -o Dpkg::Options::="--force-confold" \
            nginx="${NGINX_VERSION}" \
            nginx-module-xslt="${NGINX_VERSION}" \
            nginx-module-geoip="${NGINX_VERSION}" \
            nginx-module-image-filter="${NGINX_VERSION}" \
            nginx-module-njs="${NJS_VERSION}"; \
    # forward request and error logs to docker log collector
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    ln -sf /dev/stderr /var/log/nginx/error.log; \
    \
    \
    # Install php
    PHP_URL="https://secure.php.net/get/php-${PHP_VERSION}.tar.xz/from/this/mirror"; \
    PHP_ASC_URL="https://secure.php.net/get/php-${PHP_VERSION}.tar.xz.asc/from/this/mirror"; \
    # environment
    LIB_DEPS=" \
        libc-dev \
        libpcre3-dev \
        \
        libcurl4-openssl-dev \
        libreadline6-dev \
        libssl-dev \
        libxml2-dev \
        zlib1g-dev \
    "; \
    \
    apt-get install -y --no-install-recommends apt-transport-https ${DEV_DEPS} ${LIB_DEPS}; \
    \
    \
    wget -O php.tar.xz "${PHP_URL}"; \
    \
    if [ -n "$PHP_SHA256" ]; then \
        echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -; \
    fi; \
    \
    if [ -n "$PHP_ASC_URL" ]; then \
        wget -O php.tar.xz.asc "$PHP_ASC_URL"; \
        export GNUPGHOME="$(mktemp -d)"; \
        for key in $PHP_GPGKEYS; do \
            gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
        done; \
        gpg --batch --verify php.tar.xz.asc php.tar.xz; \
        rm -rf "$GNUPGHOME"; \
    fi; \
    \
    source /init.sh; \
    \
    locale-gen en_US.UTF-8; \
    \
    # php
    mkdir -p "${PHP_SRC_DIR}"; \
    tar -Jxf $SRC_DIR/php.tar.xz -C "${PHP_SRC_DIR}" --strip-components=1; \
    cd "${PHP_SRC_DIR}"; \
    \
    BUILD="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
    MULTIARCH="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
    \
    # Apply stack smash protection to functions using local buffers and alloca()
    # Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
    # Enable optimization (-O2)
    # Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
    # Adds GNU HASH segments to generated executables (this is used if present, and is much faster than sysv hash; in this configuration, sysv hash is also generated)
    # https://github.com/docker-library/php/issues/272
    PHP_CFLAGS="-I${PHP_SRC_DIR} -fstack-protector-strong -fpic -fpie -O2"; \
    PHP_CPPFLAGS="$PHP_CFLAGS"; \
    PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"; \
    \
    ./configure \
        CFLAGS="$PHP_CFLAGS" \
        CPPFLAGS="$PHP_CPPFLAGS" \
        LDFLAGS="$PHP_LDFLAGS" \
        --build="${BUILD}" \
        --sysconfdir="${PHP_INI_DIR}" \
        --with-libdir="lib/${MULTIARCH}" \
        --with-pcre-regex=/usr \
        \
        --disable-all \
        \
        --with-config-file-path="${PHP_INI_DIR}" \
        --with-config-file-scan-dir="${PHP_CONF_DIR}" \
        \
        --with-fpm-user=www-data \
        --with-fpm-group=www-data \
        \
        # --disable-cgi \
        # --disable-short-tags \
        \
        --enable-fpm \
        --enable-opcache \
        \
        --enable-ftp \
        --enable-mbstring \
        --enable-mysqlnd \
        \
        --with-curl \
        --with-openssl \
        --with-zlib \
        --with-readline \
        --enable-filter \
        \
        --enable-xml \
        --enable-libxml \
        --with-pear \
        --with-libxml-dir \
        \
        --without-sqlite3 \
        --without-pdo-sqlite \
    ; \
    \
    make -j "$(nproc)"; \
    make install; \
    make clean; \
    \
    PHP_EXTENSION_DIR=$(php-config --extension-dir); \
    \
    cp ${PHP_SRC_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini; \
    echo "zend_extension=opcache.so" > ${PHP_CONF_DIR}/opcache.ini; \
    \
    if [ "full" = "${BUILD_TYPE}" ]; then \
        EXTENSIONS="${EXTENSIONS} ${EXTEND_EXTENSIONS}"; \
    fi; \
    \
    \
    extensions=( $EXTENSIONS ); \
    \
    # bcmath
    if in_array extensions "bcmath"; then \
        ext-src bcmath; \
    fi; \
    \
    # bz2
    if in_array extensions "bz2"; then \
        ext-lib libbz2-dev; \
        ext-src bz2; \
    fi; \
    \
    # calendar
    if in_array extensions "calendar"; then \
        ext-src calendar; \
    fi; \
    \
    # ctype
    if in_array extensions "ctype"; then \
        ext-src ctype; \
    fi; \
    \
    # dba
    if in_array extensions "dba"; then \
        ext-src dba; \
    fi; \
    \
    # dom
    if in_array extensions "dom"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src dom; \
    fi; \
    \
    # enchant
    if in_array extensions "enchant"; then \
        ext-lib libenchant1c2a libenchant-dev; \
        ext-src enchant; \
    fi; \
    \
    # exif
    if in_array extensions "exif"; then \
        ext-src exif; \
    fi; \
    \
    # fileinfo
    if in_array extensions "fileinfo"; then \
        ext-src fileinfo; \
    fi; \
    \
    # gd
    if in_array extensions "gd"; then \
        ext-lib libjpeg-dev libpng12-dev libwebp-dev libxpm-dev libfreetype6-dev; \
        ext-src gd --with-webp-dir --with-jpeg-dir --with-png-dir --with-zlib-dir \
                   --with-xpm-dir --with-freetype-dir --enable-gd-native-ttf; \
    fi; \
    \
    # gettext
    if in_array extensions "gettext"; then \
        ext-src gettext; \
    fi; \
    \
    # gmp
    if in_array extensions "gmp"; then \
        ext-lib libgmp-dev; \
        ext-src gmp --with-gmp=/usr/include/x86_64-linux-gnu/gmp.h; \
    fi; \
    \
    # hash
    if in_array extensions "hash"; then \
        ext-src hash; \
    fi; \
    \
    # iconv
    if in_array extensions "iconv"; then \
        ext-src iconv; \
    fi; \
    \
    # intl
    if in_array extensions "intl"; then \
        ext-lib libicu-dev; \
        ext-src intl; \
    fi; \
    \
    # json
    if in_array extensions "json"; then \
        ext-src json; \
    fi; \
    \
    # pcntl
    if in_array extensions "pcntl"; then \
        ext-src pcntl; \
    fi; \
    \
    # pdo
    if in_array extensions "pdo"; then \
        ext-src pdo; \
    fi; \
    \
    # pdo mysql
    if in_array extensions "pdo_mysql"; then \
        ext-src pdo_mysql; \
    fi; \
    \
    # pdo pgsql
    if in_array extensions "pdo_pgsql"; then \
        ext-lib libpq-dev; \
        ext-src pdo_pgsql; \
    fi; \
    \
    # pdo sqlite
    if in_array extensions "pdo_sqlite"; then \
        ext-lib sqlite3 libsqlite3-dev libsqlite3-0; \
        ext-src pdo_sqlite; \
    fi; \
    \
    # phar
    if in_array extensions "phar"; then \
        ext-src phar; \
    fi; \
    \
    # posix
    if in_array extensions "posix"; then \
        ext-src posix; \
    fi; \
    \
    # pspell
    if in_array extensions "pspell"; then \
        ext-lib libpspell-dev; \
        ext-src pspell; \
    fi; \
    \
    # recode
    if in_array extensions "recode"; then \
        ext-lib librecode-dev; \
        ext-src recode; \
    fi; \
    \
    # session
    if in_array extensions "session"; then \
        ext-src session; \
    fi; \
    \
    # shmop
    if in_array extensions "shmop"; then \
        ext-src shmop; \
    fi; \
    \
    # simplexml
    if in_array extensions "simplexml"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src simplexml; \
    fi; \
    \
    # snmp
    if in_array extensions "snmp"; then \
        ext-lib libsnmp-dev snmp-mibs-downloader; \
        ext-src snmp; \
    fi; \
    \
    # soap
    if in_array extensions "soap"; then \
        ext-lib libxml2-dev; \
        ext-src soap; \
    fi; \
    \
    # sockets
    if in_array extensions "sockets"; then \
        ext-src sockets; \
    fi; \
    \
    # sqlite
    if in_array extensions "sqlite3"; then \
        ext-lib sqlite3 libsqlite3-dev libsqlite3-0; \
        ext-src sqlite3; \
    fi; \
    \
    # tidy
    if in_array extensions "tidy"; then \
        ext-lib libtidy-dev; \
        ext-src tidy; \
    fi; \
    \
    # tokenizer
    if in_array extensions "tokenizer"; then \
        ext-src tokenizer; \
    fi; \
    \
    # wddx
    if in_array extensions "wddx"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src wddx; \
    fi; \
    \
    # xml
    if in_array extensions "xml"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src xml; \
    fi; \
    \
    # xsl
    if in_array extensions "xsl"; then \
        ext-lib libxml2 libxslt1-dev; \
        ext-src xsl; \
    fi; \
    \
    # xmlreader
    if in_array extensions "xmlreader"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src xmlreader; \
    fi; \
    \
    # xmlwriter
    if in_array extensions "xmlwriter"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src xmlwriter; \
    fi; \
    \
    # xmlrpc
    if in_array extensions "xmlrpc"; then \
        ext-lib libxml2 libxml2-dev; \
        ext-src xmlrpc; \
    fi; \
    \
    # zip
    if in_array extensions "zip"; then \
        ext-src zip; \
    fi; \
    \
    \
    \
    # pecl install
    \
    # yaml
    if in_array extensions "yaml"; then \
        ext-lib libyaml-dev; \
        ext-pcl yaml-2.0.2; \
    fi; \
    \
    # apcu
    if in_array extensions "apcu"; then \
        ext-pcl apcu-5.1.8; \
    fi; \
    \
    # memcached
    if in_array extensions "memcached"; then \
        ext-lib libmemcached-dev; \
        ext-pcl memcached-3.0.3; \
    fi; \
    \
    # redis
    if in_array extensions "redis"; then \
        ext-pcl redis-3.1.3; \
    fi; \
    \
    # uuid
    if in_array extensions "uuid"; then \
        ext-lib uuid-dev; \
        ext-pcl uuid-1.0.4; \
    fi; \
    \
    # ev
    if in_array extensions "ev"; then \
        ext-lib libev-dev; \
        ext-pcl ev-1.0.4; \
    fi; \
    \
    # uv \
    if in_array extensions "uv"; then \
        ext-lib libuv1-dev; \
        ext-pcl uv-0.2.2; \
    fi; \
    \
    # ssh2
    if in_array extensions "ssh2"; then \
        ext-lib libssh2-1-dev; \
        ext-pcl ssh2-1.1.2; \
    fi; \
    \
    # phalcon
    if in_array extensions "phalcon"; then \
        PHALCON_VERSION=3.2.2; \
        cd $PECL_SRC_DIR; \
        wget https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz; \
        tar -zxvf v${PHALCON_VERSION}.tar.gz; \
        mv cphalcon-${PHALCON_VERSION}/build/php7/64bits phalcon-${PHALCON_VERSION}; \
        PREV_PHP_CFLAGS="${PHP_CFLAGS}"; \
        PHP_CFLAGS="${PHP_CFLAGS} -g -fomit-frame-pointer -DPHALCON_RELEASE"; \
        ext-pcl phalcon-${PHALCON_VERSION}; \
        PHP_CFLAGS="${PREV_PHP_CFLAGS}"; \
    fi; \
    \
    # sodium
    if in_array extensions "sodium"; then \
        SODIUM_VERSION=2.0.4; \
        cd $PECL_SRC_DIR; \
        git clone --branch=stable https://github.com/jedisct1/libsodium; \
        cd libsodium; \
        ./configure; \
        make; \
        make install; \
        cd $PECL_SRC_DIR; \
        wget https://github.com/jedisct1/libsodium-php/archive/${SODIUM_VERSION}.tar.gz; \
        tar -zxvf ${SODIUM_VERSION}.tar.gz; \
        mv libsodium-php-${SODIUM_VERSION} sodium-${SODIUM_VERSION}; \
        ext-pcl sodium-${SODIUM_VERSION}; \
    fi; \
    \
    # pdo_sqlsrv
    if in_array extensions "pdo_sqlsrv"; then \
        cd $PECL_SRC_DIR; \
        curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
        curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list; \
        apt-get update; \
        ACCEPT_EULA=Y ext-lib msodbcsql mssql-tools unixodbc-dev; \
        ext-pcl pdo_sqlsrv-4.3.0; \
    fi; \
    \
    # gearman
    if in_array extensions "gearman"; then \
        GEARMAN_VERSION=2.0.3; \
        cd $PECL_SRC_DIR; \
        ext-lib libgearman-dev; \
        git clone https://github.com/wcgallego/pecl-gearman.git gearman-${GEARMAN_VERSION}; \
        ext-pcl gearman-${GEARMAN_VERSION}; \
    fi; \
    \
    # amqp
    if in_array extensions "amqp"; then \
        LIBRABBITMQ_VERSION=0.8.0; \
        cd $PECL_SRC_DIR; \
        wget http://ftp.daum.net/ubuntu/pool/universe/libr/librabbitmq/librabbitmq4_${LIBRABBITMQ_VERSION}-1_amd64.deb; \
        dpkg -i librabbitmq4_${LIBRABBITMQ_VERSION}-1_amd64.deb; \
        wget http://ftp.daum.net/ubuntu/pool/universe/libr/librabbitmq/librabbitmq-dev_${LIBRABBITMQ_VERSION}-1_amd64.deb; \
        dpkg -i librabbitmq-dev_${LIBRABBITMQ_VERSION}-1_amd64.deb; \
        ext-pcl amqp-1.9.1; \
    fi; \
    \
    # v8js
    if in_array extensions "v8js"; then \
        LIBV8_VERSION=6.2; \
        apt-add-repository ppa:pinepain/libv8-${LIBV8_VERSION} -y; \
        apt-get update; \
        ext-lib libv8-${LIBV8_VERSION}-dev; \
        ext-pcl v8js-1.4.1 --with-v8js=/opt/libv8-${LIBV8_VERSION}; \
    fi; \
    \
    # v8
    if in_array extensions "v8"; then \
        LIBV8_VERSION=6.2; \
        apt-add-repository ppa:pinepain/libv8-${LIBV8_VERSION} -y; \
        apt-get update; \
        ext-lib libv8-${LIBV8_VERSION}-dev; \
        ext-pcl v8-0.1.9 --with-v8=/opt/libv8-${LIBV8_VERSION}; \
    fi; \
    \
    \
    # Install dockerize
    DOCKERIZE_VERSION=0.5.0; \
    cd $SRC_DIR; \
    wget https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz; \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz; \
    rm -rf dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz; \
    \
    # Install supervisor
    apt-get install -y supervisor; \
    mkdir -p /var/log/supervisor; \
    \
    # Install composer
    wget http://getcomposer.org/composer.phar; \
    chmod +x composer.phar; \
    mv composer.phar /usr/local/bin/composer; \
    \
    # Install phpunit
    wget https://phar.phpunit.de/phpunit.phar; \
    chmod +x phpunit.phar; \
    mv phpunit.phar /usr/local/bin/phpunit; \
    \
    \
    # clean
    rm -rf /init.sh; \
    { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; }; \
    apt-get clean; \
    apt-get purge --yes --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false ${DEV_DEPS} ${ADD_DEPS}; \
    rm -rf $SRC_DIR/*; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN chown -Rf www-data:www-data /var/www

WORKDIR /var/www

EXPOSE 80 443

STOPSIGNAL SIGTERM

RUN chmod +x /run.sh

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD wget -qO- localhost/healthcheck.php || exit 1

ENTRYPOINT ["/run.sh"]
