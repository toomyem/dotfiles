#!/bin/bash

PATH=$HOME/.config/lemonbar:$PATH

while true
do
   sleep 1
   echo "%{l}$(tags.sh)%{r}$(cpuload.sh) | $(xbps.sh) | $(datetime.sh)"
done | lemonbar -g 1920x28+1920+0 -p -B '#000000' -f "CaskaydiaCove NFM:style=Regular:size=12" -f "Font Awesome 5 Free Solid:style=Solid"

