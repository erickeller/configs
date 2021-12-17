#!/bin/bash
BATTINFO=`/usr/bin/acpi -b`

if [[ `echo $BATTINFO | grep -i full` ]]
then
    exit 0
fi
# suspend after notification
if [[ `echo $BATTINFO | grep Discharging` && `echo $BATTINFO | cut -f 4 -d " " | sed -e 's/%,//'` -lt 5 ]]
then
    DISPLAY=:0.0 /usr/bin/notify-send --urgency=critical "suspend" "$BATTINFO"
    sleep 30
    /usr/bin/i3lock && systemctl suspend
fi
# notify when battery is discharging and less than 15%
if [[ `echo $BATTINFO | grep Discharging` && `echo $BATTINFO | cut -f 4 -d " " | sed -e 's/%,//'` -lt 15 ]]
then
    DISPLAY=:0.0 /usr/bin/notify-send "low battery" "$BATTINFO"
fi

