#!/bin/sh

su -m nginx -c "fcgiwrap -s unix:/run/fcgiwrap.sock" &
nginx
