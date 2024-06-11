#!/bin/bash
logger "Running Autostart script" &
feh --bg-fill ~/.ucsl/wallpapers/wall_6.jpg &
picom &
dash ./bar.sh &
