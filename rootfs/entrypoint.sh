#!/bin/sh

su -s /bin/sh nginx -c "fcgiwrap -s unix:/run/fcgiwrap.sock" &
nginx
