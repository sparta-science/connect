#!/usr/bin/env bash -o errexit

curl --output /dev/null --silent --fail --location --request POST $SUBMIT_METRICS_URL \
-d @"/tmp/sparta-ui-test-metrics-url-encoded-form.txt"
