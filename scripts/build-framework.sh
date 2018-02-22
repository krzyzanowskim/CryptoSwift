#!/usr/bin/env bash

set -ex

echo "Build frameworks in directory $(pwd)"

carthage build --no-skip-current --configuration "Release" --platform all 