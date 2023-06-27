#!/bin/sh

echo "%{T2}%{T-} $(xbps-install -un | wc -l)"

