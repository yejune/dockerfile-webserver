#!/bin/bash
set -e

apt-get update && apt-get install -y --no-install-recommends \
        libsodium-dev

pecl ${lib}
