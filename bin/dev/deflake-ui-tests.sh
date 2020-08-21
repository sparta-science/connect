#!/bin/zsh

# Run UITest repetedly until first failure
# optional argument: events - run until until an event is detected

die () {
    echo >&2 "$@"
    exit 1
}

test $# -eq 0 || test "$1" = "events" || die "optional argument: events"

xc_scheme=$(dirname $0)/../xc-scheme.sh

xcode_scheme() {
    source $xc_scheme "$@"
}

rm -rf test-results
rm /tmp/events-detected-during-ui-tests.txt
killall SpartaConnect
xcode_scheme SpartaConnect clean build
time while { xcode_scheme UITests test -resultBundlePath test-results/ui-tests-$(date +%s) } do
    source $(dirname $0)/../post-sparta-metrics.sh
    test "$1" = "events" && test -f /tmp/events-detected-during-ui-tests.txt && die "stopping because of events"
done
die "completed deflaking"
