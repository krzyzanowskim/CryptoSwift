#!/bin/sh

TARGET_NAME="CryptoSwift iOS"
FRAMEWORK_NAME="CryptoSwift"
INSTALL_DIR="Frameworks/iOS"
FRAMEWORK="${INSTALL_DIR}/${FRAMEWORK_NAME}.framework"

if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

mkdir -p "${INSTALL_DIR}"

WRK_DIR="build"
DEVICE_DIR="${WRK_DIR}/Release-iphoneos/${FRAMEWORK_NAME}.framework"
SIMULATOR_DIR="${WRK_DIR}/Release-iphonesimulator/${FRAMEWORK_NAME}.framework"

xcodebuild -configuration "Release" -target "${TARGET_NAME}" -sdk iphoneos SYMROOT=$(PWD)/${WRK_DIR}
xcodebuild -configuration "Release" -target "${TARGET_NAME}" -sdk iphonesimulator SYMROOT=$(PWD)/${WRK_DIR}

lipo -create "${DEVICE_DIR}/${FRAMEWORK_NAME}" "${SIMULATOR_DIR}/${FRAMEWORK_NAME}" -output "${DEVICE_DIR}/${FRAMEWORK_NAME}"

cp -R "${DEVICE_DIR}" "${INSTALL_DIR}/"

if [ -d "${SIMULATOR_DIR}/Modules/${FRAMEWORK_NAME}.swiftmodule/" ]; then
    cp -f -R "${SIMULATOR_DIR}/Modules/${FRAMEWORK_NAME}.swiftmodule/" "${FRAMEWORK}/Modules/${FRAMEWORK_NAME}.swiftmodule/" | echo
fi

rm -r "${WRK_DIR}"