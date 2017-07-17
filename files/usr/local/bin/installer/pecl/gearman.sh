#!/bin/bash
set -e

apt-get update && apt-get install -y --no-install-recommends \
        libgearman-dev -y --allow-unauthenticated

mkdir -p /usr/src/pecl

cd /usr/src/pecl

git clone https://github.com/wcgallego/pecl-gearman.git ${lib_fullname}

phpize_install
