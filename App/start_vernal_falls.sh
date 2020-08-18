#!/usr/bin/env bash

/bin/launchctl bootstrap gui/$(id -u) sparta_science.vernal_falls.plist
result=$?

if (( result == 37 ))
then
    exit 0
else
    exit $result
fi
