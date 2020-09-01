#!/usr/bin/env bash -o errexit

curl --output /dev/null --silent --fail --location --request POST $SUBMIT_METRICS_URL \
-d @"$TMPDIR/sparta-ui-test-metrics-url-encoded-form.txt"
