#!/bin/sh

echo "$(herbstclient tag_status | tr '\t' ' ')"

