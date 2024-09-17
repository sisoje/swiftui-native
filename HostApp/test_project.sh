rm -rf TestResults.xcresult

xcodebuild \
-configuration "Debug" \
-project HostApp.xcodeproj \
-scheme HostApp \
-destination "$1" \
-disableAutomaticPackageResolution \
-resultBundlePath TestResults.xcresult \
test
