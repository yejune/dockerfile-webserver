#!/bin/bash

export DOMAIN=${DOMAIN:-"_"}
export WEBROOT=${WEBROOT:-"/var/www/public"}
export NGINX_LOCATION=${NGINX_LOCATION:-"#ADD_LOCATION"}
export NGINX_HEADER=${NGINX_HEADER:-"#NGINX_HEADER"}

export PHP_INI_DIR=${PHP_INI_DIR:-"/etc/php"}
export PHP_EXTRACONF=${PHP_EXTRACONF:-";PHP_EXTRACONF"}

export USE_DOCKERIZE=${USE_DOCKERIZE:-"yes"}

export FPM_LISTEN=${FPM_LISTEN:-"localhost:9000"}
export FASTCGI_PASS=${FASTCGI_PASS:-"localhost:9000"}

export FPM_USER=${FPM_USER:-"www-data"}
export FPM_GROUP=${FPM_GROUP:-"www-data"}

export STAGE_NAME=${STAGE_NAME:-"production"}
export NGINX_CORS_ORIGIN=${NGINX_CORS_ORIGIN:-"*"}

dockerize -template ${PHP_INI_DIR}/php-fpm.d/www.tmpl > ${PHP_INI_DIR}/php-fpm.d/www.conf
rm -rf ${PHP_INI_DIR}/php-fpm.d/www.tmpl

if [[ $FASTCGI_PASS == "unix:"* ]] ; then
    echo "";
else
    sed -i -e "s/listen.owner*/;listen.owner/g" ${PHP_INI_DIR}/php-fpm.d/www.conf
    sed -i -e "s/listen.group*/;listen.group/g" ${PHP_INI_DIR}/php-fpm.d/www.conf
    sed -i -e "s/listen.mode*/;listen.mode/g" ${PHP_INI_DIR}/php-fpm.d/www.conf
fi

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
else
    echo php_flag[display_errors] = off >> ${PHP_INI_DIR}/php-fpm.d/www.conf
fi

if [ "$STAGE_NAME" != "production" ] ; then
    sed -i -e "s/.*error_reporting\s*=\s*.*/error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_STRICT/g" ${PHP_INI_DIR}/php.ini
else
    sed -i -e "s/.*error_reporting\s*=\s*.*/error_reporting = E_ALL/g" ${PHP_INI_DIR}/php.ini
fi

# Increase the memory_limit
if [ ! -z "$PHP_MEM_LIMIT" ] ; then
    sed -i -e "s/.*memory_limit\s*=\s*.*/memory_limit = ${PHP_MEM_LIMIT}/g" ${PHP_INI_DIR}/php.ini
fi

# Increase the post_max_size
if [ ! -z "$PHP_POST_MAX_SIZE" ] ; then
    sed -i -e "s/.*post_max_size\s*=\s*.*/post_max_size = ${PHP_POST_MAX_SIZE}/g" ${PHP_INI_DIR}/php.ini
fi

# Increase the upload_max_filesize
if [ ! -z "$PHP_UPLOAD_MAX_FILESIZE" ] ; then
    sed -i -e "s/.*upload_max_filesize\s*=\s*.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/g" ${PHP_INI_DIR}/php.ini
fi

# cgi.fix_pathinfo off
# sed -i -e "s/.*cgi.fix_pathinfo\s*=\s*.*/cgi.fix_pathinfo = 0/g" ${PHP_INI_DIR}/php.ini

if [ ! -z "$NGINX_CORS"] ; then
    export NGINX_CORS_CONFIG="include /etc/nginx/cors.conf;";
else
    export NGINX_CORS_CONFIG="#include /etc/nginx/cors.conf;";
fi

dockerize -template /etc/nginx/cors.tmpl > /etc/nginx/cors.conf

rm -rf /etc/nginx/cors.tmpl

mkdir -p /etc/nginx/site.d

if [ ! -z "$USE_SSL" ] ; then
    ORG_DOMAIN=$DOMAIN
    IN=$DOMAIN
    domains=$(echo $IN | tr ";" "\n")
    for domainName in $domains
    do
        if [ ! -z "$domainName" ];
        then
            export DOMAIN=${domainName}
            dockerize -template /etc/nginx/site.d/default-ssl.tmpl > /etc/nginx/site.d/${domainName}.ssl.conf
        fi
    done
    export DOMAIN=${ORG_DOMAIN}
fi

if [ "$USE_SSL" != "only" ] ; then
    dockerize -template /etc/nginx/site.d/default.tmpl > /etc/nginx/site.d/default.conf
fi

rm -rf /etc/nginx/site.d/default-ssl.tmpl
rm -rf /etc/nginx/site.d/default.tmpl

php /usr/local/bin/docker-php-env.php >> ${PHP_INI_DIR}/php-fpm.d/www.conf

update-ca-certificates

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf
