#!/usr/bin/env bash -o errexit

curl --location --request POST 'https://qckm.io/list' \
--header "x-qm-key: $QUICK_METRIC_API_KEY" \
--header 'Content-Type: application/json' \
-d @metrics.json
