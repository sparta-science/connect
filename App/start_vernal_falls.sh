#!/usr/bin/env bash

/bin/launchctl bootstrap gui/$(id -u) sparta_science.vernal_falls.plist
result=$?

# BSD system error codes used by launchctl
# e.g. launchctl error 37
# https://github.com/apple/darwin-xnu/blob/master/bsd/sys/errno.h
EIO=5       # Input/output error
EALREADY=37 # Operation already in progress.

# On macOS Big Sur 11.0 Beta (20A5343i):
# subsequent launches of the launchctl service cause Input/output error.
# https://github.com/sparta-science/connect/issues/47#issuecomment-675864268
if [[ $(sw_vers -productVersion) == 11.* ]]
then
    IGNORE_ERROR=$EIO
else
    IGNORE_ERROR=$EALREADY
fi


if (( result == IGNORE_ERROR ))
then
    exit 0
else
    exit $result
fi
