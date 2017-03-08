FROM ubuntu:16.04

ENV PHP_RUN_DIR=/run/php \
    PHP_LOG_DIR=/var/log/php \
    PHP_INI_DIR=/etc/php \
    PHP_DATA_DIR=/var/lib/php

ENV DOCKERIZE_VERSION 0.3.0

ENV NGINX_VERSION 1.11.10

ENV PHP_VERSION 7.0.16

ENV PHALCON_VER 3.0.4

ENV LIBMEMCACHED_VERSION 1.0.18

ENV LIBRABBITMQ_VERSION 0.8.0

ENV LIBV8_VERSION 5.9

ENV PHP_LIB \
        uuid-1.0.4 \
        yaml-2.0.0 \
        apcu-5.1.8 \
        libsodium-1.0.6 \
#        amqp-1.8.0 \
#        memcached-3.0.3 \
#        v8js-1.3.4 --with-v8js=/opt/libv8-${LIBV8_VERSION} \
#        v8-0.1.3 --with-v8=/opt/libv8-${LIBV8_VERSION} \
#        ev-1.0.4 \
#        uv-0.1.2 \
         redis-3.1.1

ENV NGINX_EXTRA_CONFIGURE_ARGS \
        --sbin-path=/usr/sbin \
        --conf-path=/etc/nginx/nginx.conf \
        --with-http_ssl_module \
        --with-http_dav_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module

ENV NGINX_BUILD_DEPS \
        bzip2 \
        file \
        libbz2-dev \
        libcurl4-openssl-dev \
        openssl \
        ca-certificates \
        libssl-dev \
        libxslt1-dev \
        libxml2-dev \
        libpcre3 \
        libpcre3-dev \
        libc6 \
        libxml2 \
        git \
        wget

ENV NGINX_EXTRA_BUILD_DEPS \
        gcc \
        libc-dev \
        make \
        pkg-config \
        autoconf \
        runit \
        nano \
        less \
        curl \
        tmux

ENV PHP_BUILD_DEPS \
        mysql-client \
        libmysqlclient-dev \
        libpq-dev \
        libsasl2-dev \
        libicu-dev \
        libgmp-dev \
        libreadline6-dev \
        libjpeg-dev \
        libpng12-dev \
        libwebp-dev \
        libxpm-dev \
        libfreetype6-dev

#       libmcrypt-dev \

ENV PHP_EXTRA_BUILD_DEPS \
        re2c \
        g++ \
        bison \
        python-software-properties \
        software-properties-common

ENV PHP_EXTRA_CONFIGURE_ARGS \
        --sysconfdir=${PHP_INI_DIR} \
        --with-config-file-path=${PHP_INI_DIR} \
        --with-config-file-scan-dir=${PHP_INI_DIR}/conf.d \
        --with-fpm-user=www-data \
        --with-fpm-group=www-data \
        --with-libdir=lib64 \
        --with-libxml-dir \
        --with-openssl \
        --with-curl \
        --with-iconv \
        --with-pdo-mysql \
        --with-pdo-pgsql \
        --with-openssl \
        --with-xsl \
        --with-xml \
        --with-zlib \
        --with-bz2 \
        --with-gmp \
        --with-readline \
        --with-gd \
        --with-gettext \
        --with-freetype-dir \
        --with-jpeg-dir \
        --with-xpm-dir \
        --with-webp-dir \
        --with-png-dir \
        --enable-gd-native-ttf \
        --enable-fpm \
        --enable-opcache \
        --enable-sockets \
        --enable-bcmath \
        --enable-mbstring \
        --enable-intl \
        --enable-mysqlnd \
        --enable-zip \
        --enable-pcntl \
        --enable-calendar \
        --enable-soap \
        --disable-cgi \
        --disable-short-tags
#       --without-sqlite3 \
#       --disable-fileinfo \
#       --without-pdo-sqlite \
#       --disable-posix
#       --disable-tokenizer \
#       --with-mysql \
#       --with-mysqli \
#       --with-mcrypt \

RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list

ENV NGINX_KEY "A1C052F8"

ENV PHP7_KEY "1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3"

COPY files/ /

RUN set -x && \
    apt-get update && apt-get install -y --no-install-recommends \
    ${NGINX_BUILD_DEPS} ${NGINX_EXTRA_BUILD_DEPS} \
    ${PHP_BUILD_DEPS} ${PHP_EXTRA_BUILD_DEPS} \
    # Install nginx
    && /usr/local/bin/installer/nginx.sh \
    # Install php
    && /usr/local/bin/installer/php.sh \
    # Install php phalcon
    && /usr/local/bin/installer/phalcon.sh \
    # Install php extension
    && /usr/local/bin/installer/php-pecl.sh \
    # Install dockerize
    && /usr/local/bin/installer/dockerize.sh \
    # Install supervisor
    && /usr/local/bin/installer/supervisor.sh \
    # clean
    && { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
    && rm -rf /usr/src/pecl \
    && rm -rf /usr/src/php \
    && rm -rf /usr/src/nginx \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get clean \
    && apt-get purge --yes --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $NGINX_EXTRA_BUILD_DEPS $PHP_EXTRA_BUILD_DEPS

RUN userdel www-data && groupadd -r www-data -g 433 \
    && mkdir -p /var/www \
    && mkdir -p /var/www/public \
    && useradd -u 431 -r -g www-data -d /var/www -s /sbin/nologin -c "Docker image user for web application" www-data \
    && chown -Rf www-data:www-data /var/www \
    && chmod 711 /var/www

VOLUME ["/var/www"]

WORKDIR /var/www/

EXPOSE 80 443

RUN chmod +x /run.sh

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD wget -qO- localhost/healthcheck.php || exit 1

ENTRYPOINT ["/run.sh"]
