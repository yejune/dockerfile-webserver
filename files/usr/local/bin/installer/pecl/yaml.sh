#!/bin/bash
set -e

apt-get update && apt-get install -y --no-install-recommends \
        libyaml-dev

phpize_install
