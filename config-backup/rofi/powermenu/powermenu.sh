#!/usr/bin/env bash

# Available Styles
# >> Created and tested on : rofi 1.6.0-1
#
# column_circle     column_square     column_rounded     column_alt
# card_circle     card_square     card_rounded     card_alt
# dock_circle     dock_square     dock_rounded     dock_alt
# drop_circle     drop_square     drop_rounded     drop_alt
# full_circle     full_square     full_rounded     full_alt
# row_circle      row_square      row_rounded      row_alt

theme="full_circle"
dir="$HOME/.config/rofi/powermenu"

# random colors
styles=($(ls -p --hide="colors.rasi" $dir/styles))
color="${styles[$(($RANDOM % 8))]}"

# comment this line to disable random colors
cat >$dir/styles/colors.rasi <<-EOF
@import "$color"
element {
    width: 3%;
}
EOF

# comment these lines to disable random style
themes=($(ls -p --hide="powermenu.sh" --hide="styles" --hide="confirm.rasi" --hide="message.rasi" $dir))
theme="${themes[$(($RANDOM % 24))]}"

uptime=$(uptime | cut -d, -f1)

rofi_command="rofi -theme $dir/$theme"

# Options
shutdown=""
reboot=""
lock=""
suspend=""
logout=""

# Confirmation
confirm_exit() {
  rofi -dmenu -i -no-fixed-num-lines -p "Are You Sure? : " \
    -theme $dir/confirm.rasi
}

# Message
msg() {
  rofi -theme "$dir/message.rasi" -e "Available Options  -  yes / y / no / n"
}

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | $rofi_command -p "$uptime" -dmenu -selected-row 2)"
case $chosen in
$shutdown)
  systemctl poweroff
  ;;
$reboot)
  systemctl reboot
  ;;
$lock)
  screenlock
  ;;
$suspend)
  mpc -q pause
  amixer set Master mute
  systemctl suspend
  ;;
$logout)
  if echo ${XDG_SESSION_DESKTOP} | grep -qi "Openbox"; then
    openbox --exit
  elif echo ${XDG_SESSION_DESKTOP} | grep -qi "bspwm"; then
    bspc quit
  elif echo ${XDG_SESSION_DESKTOP} | grep -qi "i3"; then
    i3-msg exit
  fi
  ;;
esac

rm -f $dir/styles/colors.rasi
