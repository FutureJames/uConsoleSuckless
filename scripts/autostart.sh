#!/bin/bash
logger "Running Autostart script" &
upico power off vdd &
feh --bg-fill ~/.ucsl/wallpapers/gruv_10.png &
picom &
dash ./bar.sh &
