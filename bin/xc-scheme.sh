#!/usr/bin/env bash -o pipefail

echo "$@"
xcodebuild -workspace SpartaConnect.xcworkspace -scheme "$@" | xcpretty -f `bundle exec xcpretty-actions-formatter`
