#!/bin/bash
set -e

APP_NAME="SSMenuApp"
VERSION="1.2"
APP_DIR="${APP_NAME}-${VERSION}.app"
ZIP_FILE="${APP_NAME}-${VERSION}.zip"
CONTENTS="${APP_DIR}/Contents"
MACOS="${CONTENTS}/MacOS"
RESOURCES="${CONTENTS}/Resources"

echo "Building ${APP_NAME} v${VERSION}..."
swift build -c release --product ${APP_NAME}

echo "Creating app bundle..."
rm -rf "${APP_DIR}"
rm -f "${ZIP_FILE}"
mkdir -p "${MACOS}"
mkdir -p "${RESOURCES}"

# Copy binary
cp ".build/release/${APP_NAME}" "${MACOS}/${APP_NAME}"

# Create Info.plist
cat > "${CONTENTS}/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.guidong.${APP_NAME}</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>${VERSION}</string>
    <key>CFBundleVersion</key>
    <string>${VERSION}</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © guidong. All rights reserved.</string>
</dict>
</plist>
EOF

# Create PkgInfo
echo -n "APPL????" > "${CONTENTS}/PkgInfo"

# Zip for release
echo "Creating ${ZIP_FILE}..."
zip -r "${ZIP_FILE}" "${APP_DIR}"

echo ""
echo "Done! Ready for GitHub Release:"
echo "  App bundle: ${APP_DIR}"
echo "  Release zip: ${ZIP_FILE}"
