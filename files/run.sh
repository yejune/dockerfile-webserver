#!/bin/bash

export UPSTREAM=${UPSTREAM:-"localhost:9000"}
export DOMAIN=${DOMAIN:-"_"}
export WEBROOT=${WEBROOT:-"/var/www/public"}
export NGINX_LOCATION=${NGINX_LOCATION:-"#ADD_LOCATION"}
export NGINX_HEADER=${NGINX_HEADER:-"#ADD_HEADER"}

export FPM_LISTEN=${FPM_LISTEN:-"0.0.0.0:9000"}
export PHP_INI_DIR=${PHP_INI_DIR:-"/etc/php"}
export PHP_EXTRACONF=${PHP_EXTRACONF:-";ADD_EXTRACONF"}

export USE_DOCKERIZE=${USE_DOCKERIZE:-"yes"}
export FPM_USER=${FPM_USER:-"www-data"}
export FPM_GROUP=${FPM_GROUP:-"www-data"}

dockerize -template ${PHP_INI_DIR}/php-fpm.d/www.tmpl > ${PHP_INI_DIR}/php-fpm.d/www.conf
rm -rf ${PHP_INI_DIR}/php-fpm.d/www.tmpl

# Display Version Details or not
if [ ! -z "$SHOW_VERSION" ] ; then
    sed -i "s/server_tokens off;/server_tokens on;/g" /etc/nginx/nginx.conf
    sed -i "s/expose_php = Off/expose_php = On/g" ${PHP_INI_DIR}/php.ini
else
    sed -i "s/server_tokens on;/server_tokens off;/g" /etc/nginx/nginx.conf
    sed -i "s/expose_php = On/expose_php = Off/g" ${PHP_INI_DIR}/php.ini
fi

if [ ! -z "$TIMEZONE" ] ; then
    sed -i -e "s/.*date.timezone.*/date.timezone = ${TIMEZONE}/g" ${PHP_INI_DIR}/php.ini
else
    sed -i -e "s/.*date.timezone.*/date.timezone = Asia\/Seoul/g" ${PHP_INI_DIR}/php.ini
fi

# Display PHP error's or not
if [ ! -z "$DEBUG" ] ; then
    echo php_flag[display_errors] = on >> ${PHP_INI_DIR}/php-fpm.d/www.conf
    sed -i -e "s/.*error_reporting\s*=\s*.*/error_reporting = E_ALL/g" ${PHP_INI_DIR}/php.ini
else
    echo php_flag[display_errors] = off >> ${PHP_INI_DIR}/php-fpm.d/www.conf
    sed -i -e "s/.*error_reporting\s*=\s*.*/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/g" ${PHP_INI_DIR}/php.ini
fi

if [ "$STAGE" != "production" ]; then
    sed -i -e "s/.*error_reporting\s*=\s*.*/error_reporting = E_ALL/g" ${PHP_INI_DIR}/php.ini
else
    sed -i -e "s/.*error_reporting\s*=\s*.*/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/g" ${PHP_INI_DIR}/php.ini
fi

# Increase the memory_limit
if [ ! -z "$PHP_MEM_LIMIT" ]; then
    sed -i -e "s/.*memory_limit\s*=\s*.*/memory_limit = ${PHP_MEM_LIMIT}/g" ${PHP_INI_DIR}/php.ini
fi

# Increase the post_max_size
if [ ! -z "$PHP_POST_MAX_SIZE" ]; then
    sed -i -e "s/.*post_max_size\s*=\s*.*/post_max_size = ${PHP_POST_MAX_SIZE}/g" ${PHP_INI_DIR}/php.ini
fi

# Increase the upload_max_filesize
if [ ! -z "$PHP_UPLOAD_MAX_FILESIZE" ]; then
    sed -i -e "s/.*upload_max_filesize\s*=\s*.*/upload_max_filesize= ${PHP_UPLOAD_MAX_FILESIZE}/g" ${PHP_INI_DIR}/php.ini
fi

rm -rf /etc/nginx/sites-available/default
rm -rf /etc/nginx/sites-available/default-ssl
mkdir -p /etc/nginx/sites-available

if [ ! -z "$USE_SSL" ];
then
    dockerize -template /etc/nginx/default-ssl.tmpl > /etc/nginx/sites-available/default-ssl
    rm -rf /etc/nginx/default-ssl.tmpl
fi

if [ "$USE_SSL" != "only" ];
then
    dockerize -template /etc/nginx/default.tmpl > /etc/nginx/sites-available/default
    rm -rf /etc/nginx/default.tmpl
fi

/usr/local/sbin/php-fpm-env >> ${PHP_INI_DIR}/php-fpm.d/www.conf

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf
