#!/bin/bash
set -e

apt-get update && apt-get install -y --no-install-recommends \
        uuid-dev

pecl ${lib}
