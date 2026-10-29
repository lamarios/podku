{
  pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
    config.allowBroken = true;
    config.permittedInsecurePackages = [
      "gradle-7.6.6"
    ];
  },
  ci ? false,
}:

let
  aliases = [
  ];

  # Libraries needed to build and run the flutter linux desktop app
  linuxDesktopLibs = with pkgs; [
    gtk3
    glib
    pango
    cairo
    gdk-pixbuf
    harfbuzz
    at-spi2-core
    libepoxy
    fontconfig
    freetype
    libxkbcommon
    libGL
    dbus
    pcre2
    util-linux # libmount / libblkid
    libselinux
    libsepol
    libthai
    libdatrie
    lerc
    libdeflate
    libsysprof-capture
    libx11
    libxdmcp
    libxtst
    libxcursor
    libxrandr
    libxi
    libxinerama
    wayland
  ];

in
pkgs.mkShell {
  buildInputs =
    with pkgs;
    builtins.concatLists [
      [
        flutter
        git
        http-server
        fastlane
        jdk25_headless
        maven
        python313Packages.pip
        (pkgs.callPackage ./openapi-generator-cli.nix { })
      ]
      # Toolchain for `flutter build linux`
      (pkgs.lib.optionals pkgs.stdenv.isLinux (
        [
          clang
          cmake
          ninja
          pkg-config
          patchelf
          flatpak
          flatpak-builder
          appstream # appstreamcli, used by flatpak-builder
          curl
          unzip
          xz
          which
        ]
        ++ linuxDesktopLibs
      ))
    ];

  # What to run when the shell starts
  # clipiousNix.prepareShell is a helper function to sort things properly. It returns a string so it's possible to just concatenate stuff afterwards
  # to run CI or DB migrations
  shellHook = ''
     echo "Setting up mkdocs"
     python -m venv --clear mkdocs/venv
     source mkdocs/venv/bin/activate
     pip install -r mkdocs/requirements.txt


    echo "Setting up submodules"
    git submodule init
    git submodule update

    FLUTTER_SUBMODULE="${toString ./.}/submodules/flutter"

    # The flutter submodule downloads prebuilt binaries (dart sdk, engine tools) that are linked
    # against a generic linux loader, which NixOS doesn't have. Point them to the nix one instead.
    patch_flutter_submodule() {
      [ -e /etc/NIXOS ] || return 0
      local interpreter="$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker)"
      find "$FLUTTER_SUBMODULE/bin/cache/dart-sdk/bin" "$FLUTTER_SUBMODULE/bin/cache/artifacts/engine" \
        -type f -executable ! -name '*.so' ! -name '*.nixpatch' 2>/dev/null | while read -r f; do
        current="$(patchelf --print-interpreter "$f" 2>/dev/null)" || continue
        if [ "$current" != "$interpreter" ]; then
          # patch a copy and swap it in, the binary might be in use (IDE analysis server for example)
          cp -p "$f" "$f.nixpatch" \
            && patchelf --set-interpreter "$interpreter" \
              --add-rpath "${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]}" "$f.nixpatch" \
            && mv -f "$f.nixpatch" "$f" || rm -f "$f.nixpatch"
        fi
      done
    }

    if [ -e /etc/NIXOS ]; then
      echo "Patching flutter submodule binaries"
      # First call downloads the dart sdk if it's missing (and fails to run it), second one
      # fetches the desktop engine artifacts so they can be patched before the first build.
      "$FLUTTER_SUBMODULE/bin/flutter" --version >/dev/null 2>&1
      patch_flutter_submodule
      "$FLUTTER_SUBMODULE/bin/flutter" precache --linux >/dev/null 2>&1
      patch_flutter_submodule
    fi

    if "$FLUTTER_SUBMODULE/bin/flutter" --version >/dev/null 2>&1; then
      echo "Adding flutter submodule to path"
      export PATH="$FLUTTER_SUBMODULE/bin:$PATH"
    fi

    echo "Setting up pre-commit hook"
    if dart --version >/dev/null 2>&1; then
      dart run tools/setup_git_hooks.dart
    fi
    export JAVA_HOME="${pkgs.jdk25_headless}"
    # used by native-maven-plugin (mvn -Pnative native:compile) to find native-image
    export GRAALVM_HOME="${pkgs.graalvmPackages.graalvm-ce}"

    flutter config --jdk-dir ${pkgs.jdk21}/lib/openjdk

    echo "Exporting android auto emulator libraries"
    export LD_LIBRARY_PATH="${
      pkgs.lib.makeLibraryPath [
        pkgs.libcxx
        pkgs.libcxxrt
        pkgs.mpv
      ]
    }:$LD_LIBRARY_PATH"
    ${pkgs.lib.optionalString pkgs.stdenv.isLinux ''
      echo "Exporting linux desktop libraries"
      export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath linuxDesktopLibs}:$LD_LIBRARY_PATH"
    ''}
    export PKG_CONFIG_PATH="${
      pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" [
      ]
    }:$PKG_CONFIG_PATH"
    unset DESTDIR
  ''
  + pkgs.lib.concatStrings (map (x: ''echo "${x.name}: ${x.description}";'') aliases);

  ####################################################################
  # Without  this, almost  everything  fails with  locale issues  when
  # using `nix-shell --pure` (at least on NixOS).
  # See
  # + https://github.com/NixOS/nix/issues/318#issuecomment-52986702
  # + http://lists.linuxfromscratch.org/pipermail/lfs-support/2004-June/023900.html
  ####################################################################

  LOCALE_ARCHIVE =
    if pkgs.stdenv.isLinux then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
}

# vim: set tabstop=2 shiftwidth=2 expandtab:
