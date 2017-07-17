#!/bin/bash
set -e

# Install librabbitmq

mkdir -p /usr/src/pecl

cd /usr/src/pecl

wget http://ftp.daum.net/ubuntu/pool/universe/libr/librabbitmq/librabbitmq4_${LIBRABBITMQ_VERSION}-1_amd64.deb

dpkg -i librabbitmq4_${LIBRABBITMQ_VERSION}-1_amd64.deb

wget http://ftp.daum.net/ubuntu/pool/universe/libr/librabbitmq/librabbitmq-dev_${LIBRABBITMQ_VERSION}-1_amd64.deb

dpkg -i librabbitmq-dev_${LIBRABBITMQ_VERSION}-1_amd64.deb

phpize_install
