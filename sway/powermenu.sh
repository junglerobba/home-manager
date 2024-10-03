#!/usr/bin/env bash

options=(
  "cancel"
  "suspend"
  "exit"
  "reboot"
  "poweroff"
)
ret=$(printf '%s\n' "${options[@]}" | rofi -dmenu)

case $ret in
  suspend) systemctl suspend ;;
  exit) swaymsg exit ;;
  reboot) systemctl reboot ;;
  poweroff) systemctl poweroff ;;
  *) ;;
esac;
