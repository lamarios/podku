APP_VERSION ?= 0.0.0-dev
BUILD_NUMBER ?= 0

compile-linux-x64:
	mkdir -p build && dart compile exe bin/podkunnect.dart  -DAPP_VERSION=$(APP_VERSION),BUILD_NUMBER=$(BUILD_NUMBER) --target-arch x64 --target-os linux --output build/podkunnect && cd build && tar -zcvf podkunnect-x86_64.tar.gz podkunnect && rm podkunnect
compile-linux-arm:
	mkdir -p build && dart compile exe bin/podkunnect.dart   -DAPP_VERSION=$(APP_VERSION),BUILD_NUMBER=$(BUILD_NUMBER) --target-arch arm --target-os linux --output build/podkunnect &&  cd build && tar -zcvf podkunnect-arm.tar.gz podkunnect && rm podkunnect
compile-linux-arm64:
	mkdir -p build && dart compile exe bin/podkunnect.dart   -DAPP_VERSION=$(APP_VERSION),BUILD_NUMBER=$(BUILD_NUMBER) --target-arch arm64 --target-os linux --output build/podkunnect && cd build && tar -zcvf podkunnect-arm64.tar.gz podkunnect && rm podkunnect

