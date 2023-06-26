#!/bin/bash

read -s -p Pass: x
[ -z "$x" ] && exit
nohup xfreerdp /v:10.0.0.183 /d:DS /u:atm001 /audio-mode:1 /dynamic-resolution /floatbar:sticky:off,show:always -grab-keyboard /p:$x &

