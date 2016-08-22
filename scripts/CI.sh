#!/usr/bin/env bash

set -ex

OS_NAME=$TRAVIS_OS_NAME
OS_PREFIX=""

if [ $OS_NAME != "osx" ]; then
    OS_PREFIX=".$OS_NAME"
fi

export SWIFT_VERSION=$(cat "$OS_PREFIX.swift-version")

echo "Build script running as user $(whoami) in directory $(pwd)"

if [ -e "/usr/local/bin/swiftenv" ]; then
	export PATH="/usr/local/bin:$PATH"
fi

eval "$(swiftenv init -)"

swiftenv version

swiftenv install

swift build --clean dist
swift package fetch

if [ -d Packages ]; then
	if ls Packages/*/Tests 1>/dev/null 2>&1; then
		echo "Deleting subpackage tests"
		rm -r Packages/*/Tests
	fi
fi

swift build
sbexit=$?

echo "Swift build exited with code $sbexit"

if [[ $sbexit != 0 ]]; then
	exit $sbexit
fi

if [ -e "Tools/testprep.sh" ]; then
	cd Tools
	./testprep.sh
	cd ..
fi

if [ -d "Tests" ]; then
	swift test
fi
