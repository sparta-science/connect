#!/usr/bin/env bash -o pipefail

echo "$@"
xcodebuild -workspace SpartaConnect.xcworkspace -scheme "$@" | xcpretty -f `xcpretty-actions-formatter`
