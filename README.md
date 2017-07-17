# Docker Phalcon Webserver

This is a Phalcon application server image based on Nginx (with SSL support) and PHP7.

## mount
-   /var/www
    -   for your app code (e.g. using "-v /home/project/:/var/www/")
    -   with your document root in a directory named public/
-   /var/log/nginx
    -   optionally
    -   if you want to store logfiles visibly outside the container
-   /var/certs
    -   optionally
    -   if you wish to use SSL with real keys
-   /usr/local/share/ca-certificates/local
    -   optionally
    -   Adding trusted local certificates

## Env variables
-   DOMAIN
    -   optionally
    -   domain name, null
-   USE_SSL
    -   optionally
    -   if you wish to use SSL with real keys /var/certs
    -   /var/certs/${DOMAIN}.crt, /var/certs/${DOMAIN}.key
    -   yes, only, null
-   DEBUG
    -   optionally
    -   display errors
    -   yes, null
-   WEBROOT
    -   optionally, default /var/www/public
    -   app code (e.g. using "-v /home/project/:/var/www/")
    -   document root in a directory named /var/www/public/
-   SHOW_VERSION
    -   optionally
    -   php, nginx show version
    -   yes, null
-   TIMEZONE
    -   default Asia/Seoul
-   FPM_LISTEN
    -   optionally
    -   default localhost:9000
    -   /dev/shm/php-fpm.sock
-   FASTCGI_PASS
    -   optionally
    -   default localhost:9000
    -   unix:/dev/shm/php-fpm.sock
-   PHP_POST_MAX_SIZE
-   PHP_UPLOAD_MAX_FILESIZE
-   NGINX_CORS
    -   optionally
    -   enable CORS
    -   yes, null
-   NGINX_CORS_ORIGIN
    -   optionally, default *
    -   Access-Control-Allow-Origin

## version
-   UBUNTU 16.04
-   DOCKERIZE 0.5.0
-   NGINX 1.12.1
-   LIBV8 6.1
-   LIBMEMCACHED 1.0.18
-   LIBRABBITMQ 0.8.0
-   PHP 7.1.7
    -   phalcon 3.2.1
    -   redis 3.1.3
    -   yaml 2.0.0
    -   memcached 3.0.3
    -   apcu 5.1.8
    -   uuid 1.0.4
    -   ~~amqp 1.9.1~~ (optionally)
    -   ~~v8js 1.4.0~~ (optionally)
    -   ~~v8 0.1.7~~ (optionally)
    -   ~~sodium 2.0.2~~ (optionally)
    -   ~~ev 1.0.4~~ (optionally)
    -   ~~uv 0.2.2~~ (optionally)
    -   ~~ssh2 1.1.1~~ (optionally)
    -   ~~gearman 2.0.3~~ (optionally)
    -   pdo_mysql
    -   ~~pdo_sqlite~~ (optionally)
    -   ~~pdo_pgsql~~ (optionally)
    -   ~~pdo_sqlsrv~~ (optionally)

## Examples
-   run
    -   ``docker run -p 80:80 -d yejune/webserver``
-   only SSL
    -   ``docker run -p 80:80 -p 443:443 -e USE_SSL=only -v `pwd`/var/certs:/var/certs -v `pwd`/var/certs:/usr/local/share/ca-certificates/local -v `pwd`:/var/www/ -d yejune/webserver``
-   without SSL
    -   ``docker run -p 80:80 -v `pwd`:/var/www/ -d yejune/webserver``
-   using non-standard ports
    -   ``docker run -p 8080:80 -p 8443:443 -e USE_SSL=on -v `pwd`/var/certs:/var/certs -v `pwd`:/var/www/ -d yejune/webserver``
-   logfile
    -   ``docker run -p 80:80 -v `pwd`/var/log/nginx:/var/log/nginx -v `pwd`:/var/www/ -d yejune/webserver``
