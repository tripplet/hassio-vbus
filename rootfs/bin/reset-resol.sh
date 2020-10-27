#!/bin/sh

if [ $# -ne 1 ]; then
    echo "No config file"
    exit 1
fi

SERIAL_DEVICE="$(jq -r ".reset_vbus" ${1})"

if [ "$SERIAL_DEVICE" = "null" ];then
    echo "reset_vbus option not found in config file, skipping reset"
    exit 1
fi

#set -x

/usr/bin/picocom -q --imap lfcrlf --baud 19200 --noreset -t "$(echo -ne 'getpin\r\n')" -x 250 "$SERIAL_DEVICE"
/usr/bin/picocom -q --imap lfcrlf --baud 19200 --noreset -t "$(echo -ne 'setpin 0\r\n')" -X "$SERIAL_DEVICE"
/usr/bin/picocom -q --imap lfcrlf --baud 19200 --noreset -t "$(echo -ne 'getpin\r\n')" -x 1500 "$SERIAL_DEVICE"
/usr/bin/picocom -q --imap lfcrlf --baud 19200 --noreset -t "$(echo -ne 'setpin 1\r\n')" -X "$SERIAL_DEVICE"
/usr/bin/picocom -q --imap lfcrlf --baud 19200 --noreset -t "$(echo -ne 'getpin\r\n')"  -x 250 "$SERIAL_DEVICE"
