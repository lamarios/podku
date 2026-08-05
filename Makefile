export PATH := $(shell pwd)/submodules/flutter/bin:$(PATH)
# Determine this makefile's path.
# Be sure to place this BEFORE `include` directives, if any.
THIS_FILE := $(lastword $(MAKEFILE_LIST))

build-runner:
	cd ./src/main/app && dart run build_runner build --delete-conflicting-outputs

generate-client:
	rm -Rf podku_client && openapi-generator-cli generate -i http://localhost:8080/v3/api-docs.yaml -g dart-dio -o podku_client --additional-properties=serializationLibrary=json_serializable && cd podku_client && sed -i -E "s/^(\s*sdk:).*/\1 '^3.8.0'/" ./pubspec.yaml && dart run build_runner build && cd ../src/main/app && flutter clean && flutter pub get

android-auto-emulator:
	adb forward tcp:5277 tcp:5277 && SDL_VIDEODRIVER=x11 $(ANDROID_SDK_ROOT)/extras/google/auto/desktop-head-unit -c android_auto_config.ini

