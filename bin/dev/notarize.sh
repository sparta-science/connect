#!/bin/zsh

# Notarize app and wait for the response

# Required Environment variables
#
# DEVELOPER_ID_LOGIN
# DEVELOPER_ID_PASSWORD
#
# ARCHIVE=build/archive.xcarchive
# EXPORT_OPTIONS=App/export-options.plist
# APP_NAME=SpartaConnect
# BUNDLE_ID=com.spartascience.SpartaConnect

xcodebuild -exportArchive -archivePath "$ARCHIVE" \
    -exportOptionsPlist "$EXPORT_OPTIONS" \
    -exportPath build/export
ditto -c -k --keepParent "build/export/$APP_NAME.app" build/export/To-Be-Notarized.zip
xcrun altool --notarize-app \
    --primary-bundle-id "$BUNDLE_ID" \
    --username $DEVELOPER_ID_LOGIN \
    --password @env:DEVELOPER_ID_PASSWORD \
    --file build/export/To-Be-Notarized.zip \
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
xcrun stapler staple "build/export/$APP_NAME.app"
xcrun stapler validate "build/export/$APP_NAME.app"
ditto -c -k --keepParent "build/export/$APP_NAME.app" "build/export/$APP_NAME.zip"
