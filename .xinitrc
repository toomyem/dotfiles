
xrandr --output DisplayPort-1 --primary

~/.fehbg &
picom -b
pipewire &
pipewire-pulse &
wireplumber &
dunst &
signal-desktop --start-in-tray &
xscreensaver --no-splash &
spotifyd --config-path $HOME/.config/spotifyd
$HOME/lemon.sh &

setxkbmap pl

exec dbus-run-session herbstluftwm #qtile start
