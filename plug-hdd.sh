#!/bin/sh
set -e

vid=152d
pid=0567

if [ -z "$1" ]; then
  echo "Software connect/disconnect USB HDD ($vid:$pid)"
  echo "Usage: $0 in|out"
  exit 1
fi

plug-usb $1 $vid $pid
