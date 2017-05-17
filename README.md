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
-   DOCKERIZE 0.4.0
-   NGINX 1.12.0
-   LIBV8 6.0
-   LIBMEMCACHED 1.0.18
-   LIBRABBITMQ 0.8.0
-   PHP 7.1.5
    -   phalcon 3.1.2
    -   redis 3.1.2
    -   yaml 2.0.0
    -   amqp 1.9.0
    -   memcached 3.0.3
    -   apcu 5.1.8
    -   v8js 1.4.0
    -   v8 0.1.6
    -   libsodium 1.0.6
    -   uuid 1.0.4
    -   ev 1.0.4
    -   uv 0.2.1
    -   ssh2 1.0
    -   gearman 2.0.3
    -   pdo_mysql
    -   pdo_sqlite
    -   pdo_pgsql

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
