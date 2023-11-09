#!/bin/sh
dunstctl close-all;

volume_float=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed "s/Volume: //")
dunstify --timeout 1000 "$(awk "BEGIN { print($volume_float * 100) }")%"
