#!/bin/dash

# text color format
# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.ucsl/themes/gruv_bar

cpu() {
  cpu_avg=$(grep -o "^[^ ]*" /proc/loadavg)
  cpu_per=$(mpstat | grep all | awk '{printf("%.0f\n", 100-$13)}')
  printf "^c$white^  $cpu_per%%"
}

pkg_updates() {
  updates=$(timeout 20 sudo apt update | awk '/packages can be/ {print $1}')

  if [ -z "$updates" ]; then
    printf "^c$white^  Fully Updated"
  else
    printf "^c$red^  $updates"" updates"
  fi
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/axp20x-battery/capacity)"
  get_status="$(cat /sys/class/power_supply/axp20x-battery/status)"
  cutoff_val=15
  
  if [ "$get_status" = "Charging" ]; then
    printf "^c$green^  $get_capacity%%"
  else
    if [ "$bright_val" -lt "$cutoff_val" ]
      then
        printf "^c$red^ 󰂀 $get_capacity%%"
      else
        printf "^c$white^ 󰂀 $get_capacity%%"
    fi
  fi  
}

brightness() {
  bright_val=$(cat /sys/class/backlight/*/brightness)
  cutoff_val=10

  if [ "$bright_val" -gt "$cutoff_val" ]
    then
      printf "^c$red^ 󰃟 $bright_val"
    else
      printf "^c$white^ 󰃟 $bright_val"
  fi
}


audio() {
  audio_val=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')
   mute_val=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $4 }')
  
  case "$mute_val" in
    on)  printf "^c$white^ 󰕿 $audio_val%" ;;
    off) printf "^c$red^ 󰕿 X " ;; # 󰕾 󰕿 󰖀 󰝞 󰝟 󰖁 󰝝 󱄠 󱄡 󰸈
  esac
}

disk() {
  disk_val=$(df / | awk '/dev\/root/ {print $5}')
  
  printf "^c$white^  $disk_val%"
}	

mem() {
  mem_per=$(free | grep Mem | awk '{printf("%.0f\n", (1-($7/$2)) * 100)}')
  printf "^c$white^  $mem_per%%"
}

wlan() {
  wifi_val=$(cat /sys/class/net/wlan0/operstate 2>/dev/null)
  ip=$(hostname -I | awk '{print $1}')

  case "$wifi_val" in
    up)      printf "^c$white^ 󰤨 ^d^%s" " ^c$white^$ip" ;;
    dormant) printf "^c$red^ 󰤯 ^d^%s" " ^c$red^Not Connected" ;;
    down)    printf "^c$red^ 󰤯 ^d^%s" " ^c$red^Not Connected" ;;
  esac
}

clock() {
  clock_val=$(date '+%H:%M')
  
  printf "^c$white^ 󱑆 $clock_val"
}

while true; do

  sleep 1 && xsetroot -name "$updates $(battery) $(brightness) $(audio) $(disk) $(cpu) $(mem) $(wlan) $(clock)"
  
  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

done
