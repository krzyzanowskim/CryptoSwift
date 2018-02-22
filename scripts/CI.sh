#!/usr/bin/env bash

set -ex

echo "Build script running as user $(whoami) in directory $(pwd)"

if [ -e "/usr/local/bin/swiftenv" ]; then
	export PATH="/usr/local/bin:$PATH"
fi

eval "$(swiftenv init -)"

swiftenv version

swift package clean
swift package resolve

if [ -d Packages ]; then
	if ls Packages/*/Tests 1>/dev/null 2>&1; then
		echo "Deleting subpackage tests"
		rm -r Packages/*/Tests
	fi
fi

# https://github.com/krzyzanowskim/CryptoSwift/issues/418
swift build -c release -Xswiftc -enable-testing -Xswiftc -Xfrontend -Xswiftc -solver-memory-threshold -Xswiftc -Xfrontend -Xswiftc 999999999
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
	swift test -c release -Xswiftc -enable-testing -Xswiftc -DCI -Xswiftc -Xfrontend -Xswiftc -solver-memory-threshold -Xswiftc -Xfrontend -Xswiftc 999999999
fi
