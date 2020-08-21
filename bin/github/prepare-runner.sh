#!/usr/bin/env bash

# Prepare GitHub runner

# Change Local name to avoid name clash causing alert
sudo scutil --set LocalHostName "$GITHUB_WORKFLOW"
sudo scutil --set ComputerName "$GITHUB_WORKFLOW"

# Close Notification window
killall UserNotificationCenter || true

# Do not disturb the build with Notifications
npm install --global do-not-disturb-cli
do-not-disturb on

# Disable firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off
sudo /usr/libexec/ApplicationFirewall/socketfilterfw -k

# Close Finder Windows using Apple Script
sudo osascript -e 'tell application "Finder" to close windows'
