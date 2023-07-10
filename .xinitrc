#!/bin/sh

#xrandr --output DisplayPort-1 --primary

HOSTNAME="${HOSTNAME:-$(hostname)}"
[ -x "$HOME/.screenlayout/$HOSTNAME.sh" ] && "$HOME/.screenlayout/$HOSTNAME.sh"

~/.fehbg &

setxkbmap pl

picom -b
pipewire &
(sleep 1 ; pipewire-pulse) &
(sleep 1 ; wireplumber) &
dunst &
#signal-desktop --start-in-tray &
playerctld daemon

exec dbus-run-session qtile start #herbstluftwm
