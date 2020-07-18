#!/bin/zsh

# Run UITest repetedly until first failure
# optional argument: events - run until until an event is detected

die () {
    echo >&2 "$@"
    exit 1
}

test $# -eq 0 || test "$1" = "events" || die "optional argument: events"

rm -rf test-results
rm /tmp/events-detected-during-ui-tests.txt
killall SpartaConnect
set -o pipefail && xcodebuild -workspace SpartaConnect.xcworkspace -scheme SpartaConnect clean build | xcpretty
time while { set -o pipefail && xcodebuild -workspace SpartaConnect.xcworkspace -scheme UITests test -resultBundlePath test-results/ui-tests-$(date +%s) | xcpretty } do
    source $(dirname $0)/../post-sparta-metrics.sh
    test "$1" = "events" && test -f /tmp/events-detected-during-ui-tests.txt && die "stopping because of events"
done
die "completed deflaking"
