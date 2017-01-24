#!/bin/bash
set -e

mkdir -p /usr/src/pecl

cd /usr/src/pecl

wget https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz

tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz

rm -rf dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz