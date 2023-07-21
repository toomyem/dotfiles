#!/bin/bash

read -s -p Pass: x
[ -n "$x" ] || exit
echo ""
LOG=$HOME/.freerdp.log
[ -e $LOG ] && rm -f $LOG

nohup xfreerdp \
    /v:atm001-z15g8 \
    /d:DS /u:atm001 \
    /audio-mode:1 \
    /dynamic-resolution \
    /floatbar:sticky:off,show:fullscreen \
    /drive:H,$HOME \
    /cert:ignore \
    /size:1920x1080 \
    /p:$x > $LOG 2>&1 &

sleep 5

if [ $(cat $LOG | wc -l) -gt 0 ]
then
    cat $LOG
    echo "Press Enter"
    read x
fi

