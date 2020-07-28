#!/bin/sh

set -x

ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" = "armv7l" ]; then
    ARCH="armhf"
fi

BUILD_FROM=$(jq -r .build_from.$ARCH build.json)
COLLECTOR_VERSION=$(jq -r .args.COLLECTOR_VERSION build.json)
SERVER_VERSION=$(jq -r .args.SERVER_VERSION build.json)


docker build --build-arg BUILD_FROM="$BUILD_FROM" \
             --build-arg COLLECTOR_VERSION="$COLLECTOR_VERSION" \
             --build-arg SERVER_VERSION="$SERVER_VERSION" \
             --build-arg BROTLI_SUPPORT=0 \
             --tag ttobias/vbus . 
