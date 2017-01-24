#!/bin/bash
set -e

apt-get update && apt-get install -y --no-install-recommends \
        libuv1-dev

pecl ${lib}
