#!/bin/bash

while true
do
   sleep 1
   echo "%{l}$(herbstclient tag_status | tr '\t' ' ')%{r}$(LANG=C uptime | sed -e 's/.*: //') | %{T2}%{T-} $(xbps-install -un | wc -l) | $(date '+%a %d/%m/%Y %H:%M:%S')"
done | lemonbar -g 1920x28+1920+0 -p -B '#000000' -f "CaskaydiaCove NFM:style=Regular:size=12" -f "Font Awesome 5 Free Solid:style=Solid"

