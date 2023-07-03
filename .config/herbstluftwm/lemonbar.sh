#!/bin/bash

set -e

tag_empty="#808080"
tag_normal="#f0f0f0"
tag_urgent="#ff0000"
bar_bg_color="#000000"

widgets_left=(hlwm)
widgets_center=()
widgets_right=(player memory disk cpuload xbps datetime)

CACHEDIR=$HOME/.cache/lemonbar
SOCK=$CACHEDIR/lemon.sock

[ -d $CACHEDIR ] || mkdir -p $CACHEDIR
[ -e $SOCK ] && rm $SOCK
mkfifo $SOCK

declare -A widgets

cleanup() {
    rm $SOCK
}

sep() {
    echo " | "
}

datetime() {
    while true
    do
        echo "set:datetime:%{T2}%{T-} $(date '+%a %d/%m/%Y %H:%M:%S')" > $SOCK
        sleep 1
    done
}

datetime &

xbps() {
    while true
    do
        echo "set:xbps:%{A:xbps:}%{T2}%{T-} $(xbps-install -un | wc -l)%{A}" > $SOCK
        sleep 60
    done
}

xbps &

cpuload() {
    while true
    do
        echo "set:cpuload:%{T2}%{T-} $(LANG=C uptime | sed -e 's/.*: //' -e 's/,//g')" > $SOCK
        sleep 1
    done
}

cpuload &

memory() {
    while true
    do
        local m=$(LANG=C free -h | awk '/Mem/ {print $3}')
        echo "set:mamory:%{T2}%{T-}$m" > $SOCK
        sleep 1
    done
}

memory &

disk() {
    while true
    do
        local d=$(df -h --output=target,used,size / | tail +2 | awk '{out=" "out$1" "$2"/"$3} END {print out}')
        echo "set:disk:%{T2}%{T-}$d" > $SOCK
        sleep 1
    done
}

disk &

hlwm() {
    while true
    do
        local n=$(herbstclient attr tags.count)
        local tags=""

        for i in $(seq 0 $((n-1)))
        do
            local name=$(herbstclient attr tags.$i.name)
            color="%{F$tag_normal}"
            [ $(herbstclient attr tags.$i.client_count) -eq 0 ] && color="%{F$tag_empty}"
            [ $(herbstclient attr tags.$i.urgent_count) -gt 0 ] && color="%{F$tag_urgent}"
            [ $(herbstclient attr tags.focus.index) -eq $i ] && name="[$name]"
            tags="$tags $color%{A:switch-to-$i:}$name%{A}%{F-}"
        done

        local title="$(herbstclient attr clients.focus.title 2> /dev/null)"

        echo "set:hlwm:$tags | $title" > $SOCK
        sleep 1
    done
}

hlwm &

player() {
    local cmd
    playerctl -F -f "{{playerName}}:{{status}}:{{trunc(title, 30)}} ({{trunc(artist, 20)}})" metadata | while read -r cmd
    do
        local player="${cmd/:*/}"
        cmd=${cmd#$player:}
        local status="${cmd/:*/}"
        cmd=${cmd#$status:}
        case "$status" in
            Playing) cmd="$cmd %{T2}%{T-}" ;;
            Paused) cmd="$cmd %{T2}%{T-}" ;;
        esac
        echo "set:player:%{A:play-pause-$player:}$cmd%{A}" > $SOCK
    done
}

player &

show() {
    local s=""

    for i;
    do
        local w="${widgets[$i]}"
        [ "$s" != "" -a "$w" != "" ] && s="$s$(sep)"
        s="$s$w"
    done
    echo $s
}

trap cleanup EXIT

herbstclient watch tags.focus.index

while true
do
    read -r -t 1 cmd || true
    case "$cmd" in
        play-pause-*) playerctl -p "${cmd#play-pause-}" play-pause ;;
        switch-to-*) herbstclient use_index ${cmd#switch-to-} ;;
        xbps) alacritty --class Scratchpad -e sudo /bin/xbps-install -u ;;
        set:*) cmd=${cmd#set:} ; v=${cmd/:*/} ; cmd=${cmd#$v:} ; widgets[$v]="$cmd" ;;
    esac
    echo "%{l}$(show ${widgets_left[@]})%{c}$(show ${widgets_center[@]})%{r}$(show ${widgets_right[@]})"
done < $SOCK | lemonbar -g 1920x28+1920+0 -p -a 20 -B $bar_bg_color -f "CaskaydiaCove NFM:style=Regular:size=12" -f "Font Awesome 6 Free:style=Solid:size=14" > $SOCK

