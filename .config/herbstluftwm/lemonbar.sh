#!/bin/bash

set -e

tag_active="#ffffff"
tag_empty="#808080"
tag_normal="#f0f0f0"
tag_urgent="#ff0000"
bar_bg_color="#000000"

widgets_left=(hlwm wtitle)
widgets_center=()
widgets_right=(player memory cpuload xbps datetime)

CACHEDIR=$HOME/.cache/lemonbar
SOCK=$CACHEDIR/lemon.sock

[ -d $CACHEDIR ] || mkdir -p $CACHEDIR
[ -e $SOCK ] && rm $SOCK
mkfifo $SOCK

cleanup() {
    rm $SOCK
}

sep() {
    echo " | "
}

datetime() {
    echo "%{T2}%{T-} $(date '+%a %d/%m/%Y %H:%M:%S')"
}

xbps() {
    echo "%{T2}%{T-} $(xbps-install -un | wc -l)"
}

cpuload() {
    echo "%{T2}%{T-} $(LANG=C uptime | sed -e 's/.*: //' -e 's/,//g')"
}

memory() {
    echo "%{T2}%{T-} $(LANG=C free -h | awk '/Mem/ {print $3}')"
}

hlwm() {
    local n=$(herbstclient attr tags.count)
    local s=""

    for i in $(seq 0 $((n-1)))
    do
        local name=$(herbstclient attr tags.$i.name)
        color="%{F$tag_normal}"
        [ $(herbstclient attr tags.$i.client_count) -eq 0 ] && color="%{F$tag_empty}"
        [ $(herbstclient attr tags.$i.urgent_count) -gt 0 ] && color="%{F$tag_urgent}"
        [ $(herbstclient attr tags.focus.index) -eq $i ] && name="[$name]" && color="%{F$tag_active}"
        s="$s $color$name%{F-}"
    done

    echo "$s"
}

wtitle() {
    herbstclient attr clients.focus.title
}

player() {
    [ $(playerctl -ls | wc -l) -eq 0 ] && return
    local t="$(playerctl metadata title) ($(playerctl metadata artist))"
    local s="$t %{T2}%{A:play-pause:}"
    [ $(playerctl status) = "Playing" ] && s="$s"
    [ $(playerctl status) = "Paused" ] && s="$s"
    echo "$s%{A}%{T-}"
}

show() {
    local s=""

    for i;
    do
        local w="$($i)"
        [ "$s" != "" -a "$w" != "" ] && s="$s$(sep)"
        s="$s$w"
    done
    echo $s
}

trap cleanup EXIT

herbstclient watch tags.focus.index
herbstclient -i > $SOCK &

while true
do
    read -r -t 2 cmd || true
    case "$cmd" in
        play-pause) playerctl play-pause ;;
    esac
    echo "%{l}$(show ${widgets_left[@]})%{c}$(show ${widgets_center[@]})%{r}$(show ${widgets_right[@]})"
done < $SOCK | lemonbar -g 1920x28+1920+0 -p -B $bar_bg_color -f "CaskaydiaCove NFM:style=Regular:size=12" -f "Font Awesome 6 Free:style=Solid:size=14" > $SOCK

