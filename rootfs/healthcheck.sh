#!/bin/sh

set -e

TIMEOUT_MIN=$1

# Get current timestamp
NOW_TIMESTAMP=$(date +%s)

# Get time of last value in database
LAST_TIME=$(wget -q -O - "http://localhost:8099/vbus-server.cgi?format=json&timespan=single" | jq --raw-output .data[0].timestamp)

# Convert to unix timestamp
LAST_TIMESTAMP=$(date +%s -d "$LAST_TIME")

if [ $((NOW_TIMESTAMP - (LAST_TIMESTAMP + TIMEOUT_MIN*60))) -lt 0 ]; then
    # last value in database is not older than $TIMEOUT_MIN minutes => OK
    exit 0
else
    # last value in database is older than $TIMEOUT_MIN minutes => ERROR
    exit 1
fi
