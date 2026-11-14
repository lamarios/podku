build-runner:
	dart run build_runner build --delete-conflicting-outputs
generate-goldens:
	flutter test --update-goldens
build-linux:
	flutter build linux --release
run-linux: build-linux
	./build/linux/x64/release/bundle/podku

# AVD name:local port of each emulator's remote control MCP server (port 8080 on the device).
# Emulators are matched by AVD name because their serials change between starts.
MCP_FORWARDS ?= Pixel_9_Pro_XL:18080 Pixel_Tablet:18081
forward-mcp:
	@for serial in $$(adb devices | awk 'NR>1 && $$2=="device" {print $$1}'); do \
		avd=$$(adb -s $$serial emu avd name 2>/dev/null | head -1 | tr -d '\r'); \
		for mapping in $(MCP_FORWARDS); do \
			if [ "$${mapping%%:*}" = "$$avd" ]; then \
				adb -s $$serial forward tcp:$${mapping##*:} tcp:8080 >/dev/null && \
				echo "$$avd ($$serial) -> 127.0.0.1:$${mapping##*:}"; \
			fi; \
		done; \
	done
