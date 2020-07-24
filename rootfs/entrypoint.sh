#!/bin/sh

fcgiwrap -s unix:/run/fcgiwrap.sock &
nginx
