#!/bin/bash
set -e

apt-get update && apt-get install -y --no-install-recommends \
        libev-dev

pecl ${lib}
