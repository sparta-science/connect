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
    case $result in
    $EINPROGRESS ) sleep 1 ;;
    $ESRCH ) exit 0 ;;
    * ) exit $result ;;
    esac
done
