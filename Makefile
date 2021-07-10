.PHONY: frameworks

CWD := $(abspath $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))))

frameworks:
	$(CWD)/scripts/build-framework.sh
	@echo "Framework built in $(CWD)/CryptoSwift.xcframework"

all: frameworks
