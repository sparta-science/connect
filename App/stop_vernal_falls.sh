#!/usr/bin/env bash

while true
do
    /bin/launchctl bootout gui/$(id -u)/sparta_science.vernal_falls
    result=$?
    if (( result == 36 ))
    then
        sleep 1
    else
        if (( result == 3 ))
        then
            exit 0
        else
            exit $result
        fi
    fi
done
