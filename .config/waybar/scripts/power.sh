#!/bin/bash

# Power menu with wofi
chosen=$(echo -e " Lock\n Logout\n Reboot\n Shutdown" | wofi --dmenu -p "Power Menu")

case "$chosen" in
    *Lock) loginctl lock-session ;;
    *Logout) hyprctl dispatch exit ;;
    *Reboot) systemctl reboot ;;
    *Shutdown) systemctl poweroff ;;
    *) exit 1 ;;
esac
