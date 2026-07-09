export PATH := $(shell pwd)/submodules/flutter/bin:$(PATH)
# Determine this makefile's path.
# Be sure to place this BEFORE `include` directives, if any.
THIS_FILE := $(lastword $(MAKEFILE_LIST))

build-runner:
	cd ./podku_flutter && dart run build_runner build --delete-conflicting-outputs

serverpod-generate:
	cd ./podku_server && serverpod generate

serverpod-create-migrations:
	cd ./podku_server && serverpod generate && serverpod create-migration
