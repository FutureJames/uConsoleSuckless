#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/Documents/uConsoleSuckless/dwm/bar_themes/onedark

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$green^ ^b$black^  $cpu_val%%"
}

pkg_updates() {
  #updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc -l)
  updates=$(timeout 20 sudo apt update | awk '/packages can be/ {print $1}')

  if [ -z "$updates" ]; then
    printf "  ^c$white^    Fully Updated"
  else
    printf "  ^c$white^    $updates"" updates"
  fi
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/axp20x-battery/capacity)"
  get_status="$(cat /sys/class/power_supply/axp20x-battery/status)"

  if [ "$get_status" = "Charging" ]; then
    printf "^c$green^  $get_capacity"
  else 
    printf "^c$blue^ 󰂀 $get_capacity"
  fi  
}

brightness() {
  bright_val=$(cat /sys/class/backlight/*/brightness)
  printf "^c$red^  $bright_val"
}


disk() {
  disk_val=$(df / | awk '/dev\/root/ {print $5}')
  printf "^c$white^  $disk_val%"
}	

mem() {
  mem_val=$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)	
  printf "^c$blue^ ^b$black^  $mem_val"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$blue^ ^b$black^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$blue^ ^b$black^ 󰤯 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	clock_val=$(date '+%H:%M')
	printf "^c$darkblue^ ^b$black^ 󱑆 $clock_val"
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates $(battery) $(brightness) $(disk) $(cpu) $(mem) $(wlan) $(clock)"
done
