build-runner:
	dart run build_runner build --delete-conflicting-outputs
generate-goldens:
	flutter test --update-goldens
build-linux:
	flutter build linux --release
run-linux: build-linux
	./build/linux/x64/release/bundle/podku
