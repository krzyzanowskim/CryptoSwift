#!/bin/bash
set -euo pipefail

# Formatting rules live in .swiftformat (read automatically by swiftformat).
# Format the given path, or the whole repository if none is provided.
swiftformat "${1:-.}"
