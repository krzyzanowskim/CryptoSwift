#!/usr/bin/env bash

set -e

BASE_PWD="$PWD"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
OUTPUT_DIR=$( mktemp -d )
COMMON_SETUP="-project ${SCRIPT_DIR}/../CryptoSwift.xcodeproj -scheme CryptoSwift -configuration Release -quiet SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES"

# macOS
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=macOS'

mkdir -p "${OUTPUT_DIR}/macos"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release/CryptoSwift.framework" "${OUTPUT_DIR}/macos/CryptoSwift.framework"
rm -rf "${DERIVED_DATA_PATH}"

# macOS Catalyst
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=macOS,variant=Mac Catalyst'

mkdir -p "${OUTPUT_DIR}/maccatalyst"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release-maccatalyst/CryptoSwift.framework" "${OUTPUT_DIR}/maccatalyst/CryptoSwift.framework"
rm -rf "${DERIVED_DATA_PATH}"

# iOS
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=iOS'

mkdir -p "${OUTPUT_DIR}/iphoneos"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release-iphoneos/CryptoSwift.framework" "${OUTPUT_DIR}/iphoneos/CryptoSwift.framework"
rm -rf "${DERIVED_DATA_PATH}"

# iOS Simulator
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=iOS Simulator'

mkdir -p "${OUTPUT_DIR}/iphonesimulator"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release-iphonesimulator/CryptoSwift.framework" "${OUTPUT_DIR}/iphonesimulator/CryptoSwift.framework"
rm -rf "${DERIVED_DATA_PATH}"

# tvOS
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=tvOS'

mkdir -p "${OUTPUT_DIR}/appletvos"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release-appletvos/CryptoSwift.framework" "${OUTPUT_DIR}/appletvos/CryptoSwift.framework"
rm -rf "${DERIVED_DATA_PATH}"

# tvOS Simulator
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=tvOS Simulator'

mkdir -p "${OUTPUT_DIR}/appletvsimulator"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release-appletvsimulator/CryptoSwift.framework" "${OUTPUT_DIR}/appletvsimulator/CryptoSwift.framework"
rm -rf "${DERIVED_DATA_PATH}"

# watchOS
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=watchOS'

mkdir -p "${OUTPUT_DIR}/watchos"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release-watchos/CryptoSwift.framework" "${OUTPUT_DIR}/watchos/CryptoSwift.framework"
rm -rf "${DERIVED_DATA_PATH}"

# watchOS Simulator
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=watchOS Simulator'

mkdir -p "${OUTPUT_DIR}/watchsimulator"
ditto "${DERIVED_DATA_PATH}/Build/Products/Release-watchsimulator/CryptoSwift.framework" "${OUTPUT_DIR}/watchsimulator/CryptoSwift.framework"
rm -rf "${DERIVED_DATA_PATH}"

# XCFRAMEWORK
rm -rf ${SCRIPT_DIR}/../CryptoSwift.xcframework
xcrun xcodebuild -quiet -create-xcframework \
	-framework "${OUTPUT_DIR}/iphoneos/CryptoSwift.framework" \
	-framework "${OUTPUT_DIR}/iphonesimulator/CryptoSwift.framework" \
	-framework "${OUTPUT_DIR}/appletvos/CryptoSwift.framework" \
	-framework "${OUTPUT_DIR}/appletvsimulator/CryptoSwift.framework" \
	-framework "${OUTPUT_DIR}/watchos/CryptoSwift.framework" \
	-framework "${OUTPUT_DIR}/watchsimulator/CryptoSwift.framework" \
	-framework "${OUTPUT_DIR}/macos/CryptoSwift.framework" \
	-framework "${OUTPUT_DIR}/maccatalyst/CryptoSwift.framework" \
	-output ${SCRIPT_DIR}/../CryptoSwift.xcframework

# pushd ${OUTPUT_DIR}
# xcrun zip --symlinks -r -o ${BASE_PWD}/CryptoSwift.xcframework.zip CryptoSwift.xcframework
# popd

echo "✔️ CryptoSwift.xcframework"
echo ${OUTPUT_DIR}

rm -rf ${OUTPUT_DIR}
cd ${BASE_PWD}