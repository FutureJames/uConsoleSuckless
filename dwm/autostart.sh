#!/bin/bash
logger "autostart logs begin" &
feh --bg-fill ~/.dwm/wall/test.jpg &
picom &
#dash ~/.dwm/bar.sh &
~/.dwm/bar.sh &
