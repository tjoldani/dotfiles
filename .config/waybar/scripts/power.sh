#!/bin/bash

# Power menu with wofi (or rofi/fuzzel if preferred)
chosen=$(echo -e " Lock\n Logout\n Reboot\n Shutdown" | wlogout)

case "$chosen" in
    *Lock) loginctl lock-session ;;
    *Logout) hyprctl dispatch exit ;;
    *Reboot) systemctl reboot ;;
    *Shutdown) systemctl poweroff ;;
    *) exit 1 ;;
esac

