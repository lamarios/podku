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

docs-build:
	 mkdocs build -f mkdocs/mkdocs.yml -c -d ../docs/documentation
docs-serve:
	mkdocs serve -f mkdocs/mkdocs.yml

# Version of the flatpak, defaults to the one in the app pubspec. Override with APP_VERSION=1.2.3 BUILD_NUMBER=4 make flatpak
APP_VERSION ?= $(shell sed -n 's/^version: *\([^+]*\).*/\1/p' src/main/app/pubspec.yaml)
BUILD_NUMBER ?= $(shell sed -n 's/^version: *[^+]*+\(.*\)/\1/p' src/main/app/pubspec.yaml)

# Builds the desktop app as a flatpak bundle (flatpak/podku.flatpak). Needs the flathub remote for the runtime and sdk.
flatpak:
	printf 'APP_VERSION=%s\nBUILD_NUMBER=%s\nBUILD_DATE=%s\n' "$(APP_VERSION)" "$(BUILD_NUMBER)" "$$(date +%F)" > flatpak/version.env
	flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak-builder --user --force-clean --disable-rofiles-fuse --install-deps-from=flathub --state-dir=flatpak/.flatpak-builder --repo=flatpak/repo flatpak/build flatpak/com.github.lamarios.podku.yml
	flatpak build-bundle flatpak/repo flatpak/podku.flatpak com.github.lamarios.podku --runtime-repo=https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak-install: flatpak
	flatpak install --user --reinstall -y flatpak/podku.flatpak

.PHONY: flatpak flatpak-install
