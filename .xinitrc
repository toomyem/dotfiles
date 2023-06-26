
xrandr --output DisplayPort-1 --primary

~/.fehbg &
~/.lemon.sh &
picom -b
(sleep 1 ; pipewire) &
(sleep 1 ; pipewire-pulse) &
(sleep 1 ; wireplumber) &
dunst -config $HOME/.config/dunstrc &
signal-desktop --start-in-tray &
#xscreensaver --no-splash &

setxkbmap pl

exec dbus-run-session herbstluftwm
