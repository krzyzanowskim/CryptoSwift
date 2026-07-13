#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PROJECT="${SCRIPT_DIR}/../CryptoSwift.xcodeproj"
XCFRAMEWORK="${SCRIPT_DIR}/../CryptoSwift.xcframework"
OUTPUT_DIR="$( mktemp -d )"
DERIVED_DATA_PATH=""

# Clean up temporary build output on any exit (success or failure).
trap 'rm -rf "${OUTPUT_DIR}" "${DERIVED_DATA_PATH}"' EXIT

COMMON_SETUP=(
	-project "${PROJECT}"
	-scheme CryptoSwift
	-configuration Release
	-quiet
	SKIP_INSTALL=NO
	BUILD_LIBRARY_FOR_DISTRIBUTION=YES
)

# destination | Build/Products subdirectory | output slice directory
PLATFORMS=(
	"generic/platform=macOS|Release|macos"
	"generic/platform=macOS,variant=Mac Catalyst|Release-maccatalyst|maccatalyst"
	"generic/platform=iOS|Release-iphoneos|iphoneos"
	"generic/platform=iOS Simulator|Release-iphonesimulator|iphonesimulator"
	"generic/platform=tvOS|Release-appletvos|appletvos"
	"generic/platform=tvOS Simulator|Release-appletvsimulator|appletvsimulator"
	"generic/platform=watchOS|Release-watchos|watchos"
	"generic/platform=watchOS Simulator|Release-watchsimulator|watchsimulator"
)

frameworks=()
for entry in "${PLATFORMS[@]}"; do
	IFS='|' read -r destination products_subdir slice <<< "${entry}"

	DERIVED_DATA_PATH="$( mktemp -d )"
	xcrun xcodebuild build \
		"${COMMON_SETUP[@]}" \
		-derivedDataPath "${DERIVED_DATA_PATH}" \
		-destination "${destination}"

	mkdir -p "${OUTPUT_DIR}/${slice}"
	ditto \
		"${DERIVED_DATA_PATH}/Build/Products/${products_subdir}/CryptoSwift.framework" \
		"${OUTPUT_DIR}/${slice}/CryptoSwift.framework"
	rm -rf "${DERIVED_DATA_PATH}"
	DERIVED_DATA_PATH=""

	frameworks+=(-framework "${OUTPUT_DIR}/${slice}/CryptoSwift.framework")
done

# XCFRAMEWORK
rm -rf "${XCFRAMEWORK}"
xcrun xcodebuild -quiet -create-xcframework \
	"${frameworks[@]}" \
	-output "${XCFRAMEWORK}"

echo "✔️ ${XCFRAMEWORK}"
