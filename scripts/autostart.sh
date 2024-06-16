#!/bin/bash
logger "Running Autostart script" &
feh --bg-fill ~/.ucsl/wallpapers/gruv_10.png &
picom &
dash ./bar.sh &
