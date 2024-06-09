#!/bin/bash
logger "autostart logs begin" &
feh --bg-fill ~/Documents/uConsoleSuckless/dwm/wall/test.jpg &
picom &
#dash ~/.dwm/bar.sh &
~/Documents/uConsoleSuckless/dwm/bar.sh &
