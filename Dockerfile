FROM ubuntu:16.04
MAINTAINER max

ENV DEBIAN_FRONTEND noninteractive

ARG BUILD_LOCALE

SHELL ["/bin/bash", "-c"]

RUN if [ "ko" = "${BUILD_LOCALE}" ]; then \
        sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list; \
        sed -i 's/security.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list; \
    fi

ENV NGINX_VERSION 1.12.1
ENV NGINX_GPGKEY 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62

ENV PHP_VERSION 7.1.8
ENV PHP_GPGKEYS A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E
ENV PHP_SHA256="8943858738604acb33ecedb865d6c4051eeffe4e2d06f3a3c8f794daccaa2aab" PHP_MD5=""

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
    # bcmath
    ext-src bcmath; \
    \
    # bz2
    ext-lib libbz2-dev; \
    ext-src bz2; \
    \
    # calendar
    ext-src calendar; \
    \
    # ctype
    ext-src ctype; \
    \
    # dba
    # ext-src dba; \
    \
    # dom
    ext-lib libxml2 libxml2-dev; \
    ext-src dom; \
    \
    # enchant
    # ext-lib libenchant1c2a libenchant-dev; \
    # ext-src enchant; \
    \
    # exif
    # ext-src exif; \
    \
    # fileinfo
    # ext-src fileinfo; \
    \
    # gd
    # ext-lib libjpeg-dev libpng12-dev libwebp-dev libxpm-dev libfreetype6-dev; \
    # ext-src gd --with-webp-dir --with-jpeg-dir --with-png-dir --with-zlib-dir \
    #            --with-xpm-dir --with-freetype-dir --enable-gd-native-ttf; \
    \
    # gettext
    ext-src gettext; \
    \
    # gmp
    ext-lib libgmp-dev; \
    ext-src gmp --with-gmp=/usr/include/x86_64-linux-gnu/gmp.h; \
    \
    # hash
    ext-src hash; \
    \
    # iconv
    ext-src iconv; \
    \
    # intl
    ext-lib libicu-dev; \
    ext-src intl; \
    \
    # json
    ext-src json; \
    \
    # pcntl
    ext-src pcntl; \
    \
    # pdo
    ext-src pdo; \
    \
    # pdo mysql
    ext-src pdo_mysql; \
    \
    # pdo pgsql
    # ext-lib libpq-dev; \
    # ext-src pdo_pgsql; \
    \
    # pdo sqlite
    # ext-lib sqlite3 libsqlite3-dev libsqlite3-0; \
    # ext-src pdo_sqlite; \
    \
    # phar
    # ext-src phar; \
    \
    # posix
    ext-src posix; \
    \
    # pspell
    # ext-lib libpspell-dev; \
    # ext-src pspell; \
    \
    # recode
    # ext-lib librecode-dev; \
    # ext-src recode; \
    \
    # session
    ext-src session; \
    \
    # shmop
    # ext-src shmop; \
    \
    # simplexml
    ext-lib libxml2 libxml2-dev; \
    ext-src simplexml; \
    \
    # snmp
    # ext-lib libsnmp-dev snmp-mibs-downloader; \
    # ext-src snmp; \
    \
    # soap
    ext-lib libxml2-dev; \
    ext-src soap; \
    \
    # sockets
    ext-src sockets; \
    \
    # sqlite
    # ext-lib sqlite3 libsqlite3-dev libsqlite3-0; \
    # ext-src sqlite3; \
    \
    # tidy
    # ext-lib libtidy-dev; \
    # ext-src tidy; \
    \
    # tokenizer
    # ext-src tokenizer; \
    \
    # wddx
    # ext-lib libxml2 libxml2-dev; \
    # ext-src wddx; \
    \
    # xml
    ext-lib libxml2 libxml2-dev; \
    ext-src xml; \
    \
    # xsl
    # ext-lib libxml2 libxslt1-dev; \
    # ext-src xsl; \
    \
    # xmlreader
    ext-lib libxml2 libxml2-dev; \
    ext-src xmlreader; \
    \
    # xmlwriter
    ext-lib libxml2 libxml2-dev; \
    ext-src xmlwriter; \
    \
    # xmlrpc
    # ext-lib libxml2 libxml2-dev; \
    # ext-src xmlrpc; \
    \
    # zip
    # ext-src zip; \
    \
    \
    \
    # pecl install
    \
    # yaml
    ext-lib libyaml-dev; \
    ext-pcl yaml-2.0.2; \
    \
    # apcu
    ext-pcl apcu-5.1.8; \
    \
    # memcached
    ext-lib libmemcached-dev; \
    ext-pcl memcached-3.0.3; \
    \
    # redis
    ext-pcl redis-3.1.3; \
    \
    # uuid
    ext-lib uuid-dev; \
    ext-pcl uuid-1.0.4; \
    \
    # ev
    # ext-lib libev-dev; \
    # ext-pcl ev-1.0.4; \
    \
    # uv \
    # ext-lib libuv1-dev; \
    # ext-pcl uv-0.2.2; \
    \
    # ssh2
    # ext-lib libssh2-1-dev; \
    # ext-pcl ssh2-1.1.2; \
    \
    # phalcon
    PHALCON_VERSION=3.2.2; \
    cd $PECL_SRC_DIR; \
    wget https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz; \
    tar -zxvf v${PHALCON_VERSION}.tar.gz; \
    mv cphalcon-${PHALCON_VERSION}/build/php7/64bits phalcon-${PHALCON_VERSION}; \
    PREV_PHP_CFLAGS="${PHP_CFLAGS}"; \
    PHP_CFLAGS="${PHP_CFLAGS} -g -fomit-frame-pointer -DPHALCON_RELEASE"; \
    ext-pcl phalcon-${PHALCON_VERSION}; \
    PHP_CFLAGS="${PREV_PHP_CFLAGS}"; \
    \
    # sodium
    # SODIUM_VERSION=2.0.4; \
    # cd $PECL_SRC_DIR; \
    # git clone --branch=stable https://github.com/jedisct1/libsodium; \
    # cd libsodium; \
    # ./configure; \
    # make; \
    # make install; \
    # cd $PECL_SRC_DIR; \
    # wget https://github.com/jedisct1/libsodium-php/archive/${SODIUM_VERSION}.tar.gz; \
    # tar -zxvf ${SODIUM_VERSION}.tar.gz; \
    # mv libsodium-php-${SODIUM_VERSION} sodium-${SODIUM_VERSION}; \
    # ext-pcl sodium-${SODIUM_VERSION}; \
    \
    # pdo_sqlsrv
    # cd $PECL_SRC_DIR; \
    # curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
    # curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list; \
    # apt-get update; \
    # ACCEPT_EULA=Y ext-lib msodbcsql mssql-tools unixodbc-dev; \
    # ext-pcl pdo_sqlsrv-4.3.0; \
    \
    # gearman
    # GEARMAN_VERSION=2.0.3; \
    # cd $PECL_SRC_DIR; \
    # ext-lib libgearman-dev; \
    # git clone https://github.com/wcgallego/pecl-gearman.git gearman-${GEARMAN_VERSION}; \
    # ext-pcl gearman-${GEARMAN_VERSION}; \
    \
    # amqp
    # LIBRABBITMQ_VERSION=0.8.0; \
    # cd $PECL_SRC_DIR; \
    # wget http://ftp.daum.net/ubuntu/pool/universe/libr/librabbitmq/librabbitmq4_${LIBRABBITMQ_VERSION}-1_amd64.deb; \
    # dpkg -i librabbitmq4_${LIBRABBITMQ_VERSION}-1_amd64.deb; \
    # wget http://ftp.daum.net/ubuntu/pool/universe/libr/librabbitmq/librabbitmq-dev_${LIBRABBITMQ_VERSION}-1_amd64.deb; \
    # dpkg -i librabbitmq-dev_${LIBRABBITMQ_VERSION}-1_amd64.deb; \
    # ext-pcl amqp-1.9.1; \
    \
    # v8js
    # LIBV8_VERSION=6.2; \
    # apt-add-repository ppa:pinepain/libv8-${LIBV8_VERSION} -y; \
    # apt-get update; \
    # ext-lib libv8-${LIBV8_VERSION}-dev; \
    # ext-pcl v8js-1.4.1 --with-v8js=/opt/libv8-${LIBV8_VERSION}; \
    \
    # v8
    # LIBV8_VERSION=6.2; \
    # apt-add-repository ppa:pinepain/libv8-${LIBV8_VERSION} -y; \
    # apt-get update; \
    # ext-lib libv8-${LIBV8_VERSION}-dev; \
    # ext-pcl v8-0.1.8 --with-v8=/opt/libv8-${LIBV8_VERSION}; \
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
