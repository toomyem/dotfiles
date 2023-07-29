#!/bin/sh

#xrandr --output DisplayPort-1 --primary

HOSTNAME="${HOSTNAME:-$(hostname)}"
[ -x "$HOME/.screenlayout/$HOSTNAME.sh" ] && "$HOME/.screenlayout/$HOSTNAME.sh"

[ -x ~/.fehbg ] && ~/.fehbg &

setxkbmap pl

picom -b
playerctld daemon

pipewire &
sleep 1
pipewire-pulse &
wireplumber &
dunst &
syncthing serve --no-browser >$HOME/.syncthing.log 2>&1 &

exec dbus-run-session dk #qtile start #herbstluftwm
