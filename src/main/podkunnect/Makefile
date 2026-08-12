compile-linux-x64:
	mkdir -p build && dart compile exe bin/podkunnect.dart  --target-arch x64 --target-os linux --output build/podkunnect && cd build && tar -zcvf podkunnect-x86_64.tar.gz podkunnect && rm podkunnect
compile-linux-arm:
	mkdir -p build && dart compile exe bin/podkunnect.dart  --target-arch arm --target-os linux --output build/podkunnect &&  cd build && tar -zcvf podkunnect-arm.tar.gz podkunnect && rm podkunnect
compile-linux-arm64:
	mkdir -p build && dart compile exe bin/podkunnect.dart  --target-arch arm64 --target-os linux --output build/podkunnect && cd build && tar -zcvf podkunnect-arm64.tar.gz podkunnect && rm podkunnect

