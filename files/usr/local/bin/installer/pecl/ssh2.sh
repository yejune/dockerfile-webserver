#!/bin/bash
set -e

apt-get update && apt-get install -y --no-install-recommends \
        libssh2-1-dev

pecl ${lib}
