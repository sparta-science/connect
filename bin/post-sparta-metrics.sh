#!/usr/bin/env bash -o errexit

curl --location --request POST "https://dev-sparta-connect.herokuapp.com/proxy/google-sheets/1wxfcYqpjhxpCDaNa61t8dTzJij7OYRVX47JAXKYyEL0/values/Inputs!A1:append?insertDataOption=INSERT_ROWS&valueInputOption=USER_ENTERED&pizzly_pkey=$PIZZLY_PKEY" \
--header "Pizzly-Auth-Id: $PIZZLY_AUTH_ID" \
--header 'Content-Type: application/json' \
-d @/tmp/sparta-ui-test-metrics.json
