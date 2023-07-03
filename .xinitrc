#!/bin/sh

xrandr --output DisplayPort-1 --primary
setxkbmap pl

~/.fehbg &

picom -b
pipewire &
(sleep 1 ; pipewire-pulse) &
(sleep 1 ; wireplumber) &
dunst &
signal-desktop --start-in-tray &
playerctld daemon

exec dbus-run-session herbstluftwm
