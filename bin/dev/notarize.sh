#!/bin/zsh

# Notarize app and wait for the response

xcodebuild -exportArchive -archivePath build/archive.xcarchive \
    -exportOptionsPlist App/export-options.plist \
    -exportPath build/export
ditto -c -k --keepParent build/export/SpartaConnect.app build/export/SpartaConnect-Unnotarized.zip
xcrun altool --notarize-app \
    --primary-bundle-id "com.spartascience.SpartaConnect" \
    --username $DEVELOPER_ID_LOGIN \
    --password @env:DEVELOPER_ID_PASSWORD \
    --file build/export/SpartaConnect-Unnotarized.zip \
    --output-format xml > build/notarizing-request.plist
request=$(/usr/libexec/PlistBuddy -c "Print :notarization-upload:RequestUUID"  build/notarizing-request.plist)
echo Notarization Request ID: $request
request_status="in progress"
while [[ "$request_status" == "in progress" ]]; do
    echo -n "waiting... "
    sleep 30
    xcrun altool --notarization-info $request \
        --username $DEVELOPER_ID_LOGIN \
        --password @env:DEVELOPER_ID_PASSWORD \
        --output-format xml > build/notarization-request-status.plist
    request_status=$(/usr/libexec/PlistBuddy -c "Print :notarization-info:Status"  build/notarization-request-status.plist)
    echo $request_status
done
xcrun stapler staple build/export/SpartaConnect.app
ditto -c -k --keepParent build/export/SpartaConnect.app build/export/SpartaConnect.zip
