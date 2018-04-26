#!/bin/sh
set -e

init_args() {
  if [ -z "$3" ]; then
    echo "Software connect/disconnect USB device"
    echo "Usage: $0 in|out <device-VID> <device-PID>"
    exit 1
  fi
  vid=$2
  pid=$3
  idfile=/tmp/plug-usb-$vid-$pid
  [ "$(whoami)" = "root" ] || SUDO=sudo
}

find_device() {
  cd /sys/bus/usb/drivers/usb
  for dir in $(ls -d *-*)
  do
    [ "$(cat $dir/idVendor)" = "$vid" ] && [ "$(cat $dir/idProduct)" = "$pid" ] && echo $dir && return
  done
}

plug_in() {
  if [ ! -f $idfile ]; then
    lsusb -d $vid:$pid > /dev/null
    local rc=$?
    if [ $rc -eq 0 ]; then
      echo "The device $vid:$pid is already plugged in. Quit"
      exit 11 
    else
      echo "Cannot find plug-out record of device $vid:$pid. Quit"
      exit 12
    fi
  fi
  local num=$(cat $idfile)
  if [ -z "$num" ]; then
    echo "Cannot find device $vid:$pid. Quit"
    exit 13
  fi
  echo "Found device $vid:$pid at $num"
  echo "Plug in device $num"
  echo $num | $SUDO tee /sys/bus/usb/drivers/usb/bind > /dev/null
  rm $idfile
}

plug_out() {
  local num=$(find_device $vid $pid)
  if [ -z "$num" ]; then
    echo "Cannot find device $vid:$pid (already plugged out?). Quit"
    exit 21
  fi
  echo "Found device $vid:$pid at $num"
  echo "Plug out device $num"
  echo $num | $SUDO tee /sys/bus/usb/drivers/usb/unbind > /dev/null
  echo $num > $idfile
}

init_args $*
plug_$1
