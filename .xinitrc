
xrandr --output DisplayPort-1 --primary

~/.fehbg &
~/.config/lemonbar/lemon.sh &
picom -b
(sleep 1 ; pipewire) &
(sleep 1 ; pipewire-pulse) &
(sleep 1 ; wireplumber) &
dunst &
signal-desktop --start-in-tray &
#xscreensaver --no-splash &

setxkbmap pl

exec dbus-run-session herbstluftwm
