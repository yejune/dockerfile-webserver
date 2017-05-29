#!/bin/bash
set -e

NGINX_KEY="A1C052F8"

gpg --keyserver hkp://keys.gnupg.net --recv-key ${NGINX_KEY}

mkdir -p /var/log/nginx

curl -SL "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -o nginx.tar.bz2

curl -SL "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc" -o nginx.tar.bz2.asc

gpg --verify nginx.tar.bz2.asc

mkdir -p /usr/src/nginx

tar -xof nginx.tar.bz2 -C /usr/src/nginx --strip-components=1

rm nginx.tar.bz2*

pushd /usr/src/nginx

./configure ${NGINX_EXTRA_CONFIGURE_ARGS}

make -j"$(nproc)"

make install

make clean

# Forward request and error logs to docker log collector

ln -sf /dev/stdout /var/log/nginx/access.log

ln -sf /dev/stderr /var/log/nginx/error.log

popd

rm -rf /usr/src/nginx
