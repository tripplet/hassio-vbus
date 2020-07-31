#!/bin/sh

docker run --rm -it --entrypoint sh -v /usr/share/hassio/addons/data/fac19ebf_vbus/:/data ttobias/vbus
