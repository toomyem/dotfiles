#!/bin/bash

set -e

tag_empty="#808080"
tag_normal="#f0f0f0"
tag_urgent="#ff0000"
bar_fg_color="#c0c0c0"
bar_bg_color="#000000"

CACHEDIR=$HOME/.cache/lemonbar
SOCK=$CACHEDIR/lemon.sock

[ -d "$CACHEDIR" ] || mkdir -p "$CACHEDIR"
[ -r "$SOCK" ] && rm -f "$SOCK"
mkfifo "$SOCK"

cleanup() {
	rm "$SOCK"
	kill 0
}

trap cleanup EXIT INT TERM

sep() {
	echo " ┃ "
}

trim() {
	local s max

	s="$1"
	max="$2"
	[ "${#s}" -gt "$max" ] && s="${s:0:$max}…"
	echo "$s"
}

network() {
	local s

	s=$(ping -c 1 -w 1 -q 8.8.8.8 >/dev/null 2>&1 && echo "%{T2}%{T-}")
	echo "$s"
}

calendar() {
	echo " $(date '+%a %d/%m %H:%M:%S')"
}

xbps() {
	local color updates

	updates=$(xbps-install -un | wc -l)
	[ "$updates" -gt 0 ] && updates="%{F$tag_urgent}$updates%{F-}"
	echo "%{A:xbps:} $updates%{A}"
}

cpuload() {
	echo "$(LANG=C uptime | sed -e 's/.*: //' -e 's/,//g')"
}

memory() {
	echo "$(LANG=C free -h | awk '/Mem/ {print $3}')"
}

disk() {
	echo "$(df -h --output=target,used,size,pcent / | tail +2 | awk '{out=out" "$2"/"$3" ("$4")"} END {print out}')"
}

hlwm() {
	local n
	local tags
	local name
	local title

	while true; do
		n=$(herbstclient attr tags.count)
		tags=""

		for i in $(seq 0 $((n - 1))); do
			name=$(herbstclient attr tags."$i".name)
			color="%{F$tag_normal}"
			[ "$(herbstclient attr tags.$i.client_count)" -eq 0 ] && color="%{F$tag_empty}"
			[ "$(herbstclient attr tags.$i.urgent_count)" -gt 0 ] && color="%{F$tag_urgent}"
			[ "$(herbstclient attr tags.focus.index)" -eq "$i" ] && name="[$name]"
			tags="$tags $color%{A:switch-to-$i:}$name%{A}%{F-}"
		done

		title="$(herbstclient attr clients.focus.title 2>/dev/null)"
		[ ${#title} -gt 30 ] && title="${title:0:30}…"

		echo "set:hlwm:$tags | $title" >"$SOCK"
		sleep 1
	done
}

desktops() {
	declare -a WS
	local ws w wn s

	IFS=: read -r -a WS <<< "$(dkcmd status type=ws num=1)"
	for ws in "${WS[@]}"
	do
		w=""
		wn="${ws:1}"
		case "$ws" in
			i*) w="%{F$tag_empty} ${wn} %{F-}" ;;
			I*) w="%{F$tag_empty}[${wn}]%{F-}" ;;
			a*) w="%{F$tag_normal} ${wn} %{F-}" ;;
			A*) w="%{F$tag_normal}[${wn}]%{F-}" ;;
		esac
		s="$s%{A:ws-$wn:}$w%{A}"
	done

	echo "$s"
}

window() {
	trim "$(dkcmd status type=win num=1)" 50
}

player() {
	local title m
	
        m="$(playerctl -s -a -f '{{status}}:{{title}} ({{artist}})' metadata | sort -r | head -1)"
	m=$(trim "$m" 50)
	case "$m" in
		Playing:*) m="${m#Playing:} " ;;
		Paused:*) m="${m#Paused:} " ;;
	esac
	[ -n "$m" ] && m="%{A:play-pause:}$m%{A}"
	echo "$m"
}

show() {
	local s=""
	local w

	for i; do
		w="$($i)"
		[ "$s" != "" ] && [ "$w" != "" ] && s="$s$(sep)"
		s="$s$w"
	done
	echo "$s"
}

dkcmd status >"$SOCK" &

while true; do
	read -r -t 1 cmd || true
	case "$cmd" in
	  play-pause) playerctl -p playerctld play-pause ;;
	  switch-to-*) herbstclient use_index "${cmd#switch-to-}" ;;
	  xbps) alacritty --class Scratchpad -e sudo /bin/xbps-install -u ;;
	  ws-*) dkcmd win ws="${cmd#ws-}" ;;
	esac
	echo "%{l}$(show desktops window)%{c}$(show )%{r}$(show player cpuload memory disk network xbps calendar)"
done <"$SOCK" | lemonbar -g 1600x28+0+0 -p -a 20 -F "$bar_fg_color" -B "$bar_bg_color" -f "Terminus:size=12" -f "FontAwesome:size=12" >"$SOCK"

