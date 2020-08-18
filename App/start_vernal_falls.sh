#!/usr/bin/env bash

/bin/launchctl bootstrap gui/$(id -u) sparta_science.vernal_falls.plist
result=$?

# BSD system error codes used by launchctl
# e.g. launchctl error 37
# https://github.com/apple/darwin-xnu/blob/master/bsd/sys/errno.h
EALREADY=37 # Operation already in progress.

if (( result == EALREADY ))
then
    exit 0
else
    exit $result
fi
