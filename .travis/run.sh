#!/bin/sh
set -e

pwd
ls -la
xcodebuild -list -project Balanced.xcodeproj
xctool -project Balanced.xcodeproj -scheme Balanced test