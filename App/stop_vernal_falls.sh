#!/bin/sh

stop_command="/bin/launchctl bootout gui/$(id -u)/sparta_science.vernal_falls"
echo $stop_command

while [ eval ($stop_command -eq 37) ]
do
    sleep 1
done
