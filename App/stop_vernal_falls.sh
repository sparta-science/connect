#!/usr/bin/env bash

# BSD system error codes used by launchctl
# e.g. launchctl error 36
# https://github.com/apple/darwin-xnu/blob/master/bsd/sys/errno.h
EINPROGRESS=36 # Operation now in progress
ESRCH=3        # No such process

while true
do
    /bin/launchctl bootout gui/$(id -u)/sparta_science.vernal_falls
    result=$?
    if (( result == EINPROGRESS ))
    then
        sleep 1
    else
        if (( result == ESRCH ))
        then
            exit 0
        else
            exit $result
        fi
    fi
done
