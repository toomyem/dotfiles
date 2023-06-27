#!/bin/sh

echo "%{T2}%{T-} $(LANG=C uptime | sed -e 's/.*: //' -e 's/,//g')"

