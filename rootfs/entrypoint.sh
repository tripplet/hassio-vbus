#!/bin/sh

set -e

# Start the collector (in background)
/bin/vbus-collector --config /data/options.json &

# Print vbus-server version
/htdocs/vbus-server.cgi --version

# Start the fcgi process (in background)
su -s /bin/sh nginx -c "fcgiwrap -s unix:/run/fcgiwrap.sock" &

# Start nginx
nginx -v
nginx
