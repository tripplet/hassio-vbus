#!/bin/sh

set -e

/bin/vbus-collector --config /data/options.json &
su -s /bin/sh nginx -c "fcgiwrap -s unix:/run/fcgiwrap.sock" &
nginx
