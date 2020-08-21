#!/usr/bin/env bash

echo "$@"

set -o pipefail

xcodebuild -workspace SpartaConnect.xcworkspace -scheme "$@" | xcpretty -f `bundle exec xcpretty-actions-formatter`
