#!/bin/bash
set -e

if [ "$ACTION" = "" ] ; then

    rm -rf "$CONFIGURATION_BUILD_DIR/staging"
    rm -f "Sparkle-$CURRENT_PROJECT_VERSION.tar.bz2"

    mkdir -p "$CONFIGURATION_BUILD_DIR/staging"
    cp "$SRCROOT/CHANGELOG" "$SRCROOT/LICENSE" "$SRCROOT/Resources/SampleAppcast.xml" "$CONFIGURATION_BUILD_DIR/staging"
    cp -R "$SRCROOT/bin" "$CONFIGURATION_BUILD_DIR/staging"
    cp "$CONFIGURATION_BUILD_DIR/BinaryDelta" "$CONFIGURATION_BUILD_DIR/staging/bin"
    cp "$CONFIGURATION_BUILD_DIR/generate_appcast" "$CONFIGURATION_BUILD_DIR/staging/bin"
    cp "$CONFIGURATION_BUILD_DIR/generate_keys" "$CONFIGURATION_BUILD_DIR/staging/bin"
    cp "$CONFIGURATION_BUILD_DIR/sign_update" "$CONFIGURATION_BUILD_DIR/staging/bin"
    cp -R "$CONFIGURATION_BUILD_DIR/Sparkle Test App.app" "$CONFIGURATION_BUILD_DIR/staging"
    cp -R "$CONFIGURATION_BUILD_DIR/Sparkle.framework" "$CONFIGURATION_BUILD_DIR/staging"

    # Only copy dSYMs for Release builds, but don't check for the presence of the actual files
    # because missing dSYMs in a release build SHOULD trigger a build failure
    if [ "$CONFIGURATION" = "Release" ] ; then
        cp -R "$CONFIGURATION_BUILD_DIR/BinaryDelta.dSYM" "$CONFIGURATION_BUILD_DIR/staging/bin"
        cp -R "$CONFIGURATION_BUILD_DIR/generate_appcast.dSYM" "$CONFIGURATION_BUILD_DIR/staging/bin"
        cp -R "$CONFIGURATION_BUILD_DIR/generate_keys.dSYM" "$CONFIGURATION_BUILD_DIR/staging/bin"
        cp -R "$CONFIGURATION_BUILD_DIR/sign_update.dSYM" "$CONFIGURATION_BUILD_DIR/staging/bin"
        cp -R "$CONFIGURATION_BUILD_DIR/Sparkle Test App.app.dSYM" "$CONFIGURATION_BUILD_DIR/staging"
        cp -R "$CONFIGURATION_BUILD_DIR/Sparkle.framework.dSYM" "$CONFIGURATION_BUILD_DIR/staging"
    fi

    cd "$CONFIGURATION_BUILD_DIR/staging"
    # Sorted file list groups similar files together, which improves tar compression
    find . \! -type d | rev | sort | rev | tar cjvf "../Sparkle-$CURRENT_PROJECT_VERSION.tar.bz2" --files-from=-
    rm -rf "$CONFIGURATION_BUILD_DIR/staging"
fi
