# Print Mac serial number

/usr/libexec/PlistBuddy -c "Print IORegistryEntryChildren:0:IOPlatformSerialNumber" \
/dev/stdin <<< $(ioreg -c IOPlatformExpertDevice -d 2 -a)
