# Software connect/disconnect USB devices

Plug in/out USB devices by software.

- Platform: Linux (tested on Debian 9.x, kernel 4.9.x)
- Ver: 0.1
- Updated: 5/26/2018
- Created: 4/26/2018
- Author: loblab

## Why?

I use a USB HDD holder (supports 4 disks) connected with a Linux server for daily backup.
It is not power saving in idle (21 watt with 2 disks installed).
If unplug the device, the power consumption falls down to 6 watt.
So we can disconnect the device by software to save power.

## Usage

1. Use lsusb to find VID/PID of your device;
2. Run "./plug-usb.sh out VID PID" to unplug the device;
3. Run "./plug-usb.sh in VID PID" to plug the device again.

You may need to add "./plug-usb.sh out ..." to your startup script to unplug the device by default.

## How?

Write device ID string to unbind & bind file.

```bash
echo '2-1.2' > /sys/bus/usb/drivers/usb/unbind
echo '2-1.2' > /sys/bus/usb/drivers/usb/bind
```

The number may change after reboot, so I search it by VID & PID in sub directories of /sys/bus/usb/drivers/usb.

## References

- [Turning off power to usb port. Or turn off power to entire usb subsystem](https://unix.stackexchange.com/questions/165447/turning-off-power-to-usb-port-or-turn-off-power-to-entire-usb-subsystem)

