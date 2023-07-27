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
polybar -r &
syncthing serve --no-browser --logfile $HOME/.syncthing.log &

exec dbus-run-session dk #qtile start #herbstluftwm
