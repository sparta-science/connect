#!/bin/zsh

rm -rf test-results
rm /tmp/stop-ui-tests.txt
killall SpartaConnect
set -o pipefail && xcodebuild -workspace SpartaConnect.xcworkspace -scheme SpartaConnect clean build | xcpretty
time while { set -o pipefail && xcodebuild -workspace SpartaConnect.xcworkspace -scheme UITests test -resultBundlePath test-results/ui-tests-$(date +%s) | xcpretty } do
    test -f /tmp/stop-ui-tests.txt && exit 5
done
