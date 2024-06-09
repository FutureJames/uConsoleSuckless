#!/bin/bash

oldValue=$(</sys/class/backlight/backlight@0/brightness)

if [[ $1 == "-up" ]]; then
	newValue=$(($oldValue + 1))
elif [[ $1 == "-down" ]]; then
	newValue=$(($oldValue - 1))
else
	echo "Usage:"
	echo "./brightness.sh -up"
	echo "./brightness.sh -down"
	exit 2
fi

echo $newValue > /sys/class/backlight/backlight@0/brightness

exit 0

