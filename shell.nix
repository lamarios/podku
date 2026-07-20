# Using a fixed nix commit for maximum reproducability
{ pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
    config.allowBroken = true;
    config.permittedInsecurePackages = [
                    "gradle-7.6.6"
                  ];
  }
, ci ? false}:

let
 aliases = [
     ];


in
pkgs.mkShell {
  buildInputs = with pkgs; builtins.concatLists [
    [ flutter git http-server serverpod_cli fastlane gst_all_1.gstreamer
      gst_all_1.gstreamer
           gst_all_1.gst-plugins-base
           gst_all_1.gst-plugins-good
           gst_all_1.gst-plugins-bad
           gtk3
     ]
  ];

  # What to run when the shell starts
  # clipiousNix.prepareShell is a helper function to sort things properly. It returns a string so it's possible to just concatenate stuff afterwards
  # to run CI or DB migrations
  shellHook =  ''

  echo "Setting up submodules"
  git submodule init
  git submodule update

  echo "Setting up pre-commit hook"
  dart run tools/setup_git_hooks.dart

  echo "Adding flutter submodule to path"
  export PATH="./submodules/flutter/bin:$PATH"


  flutter config --jdk-dir ${pkgs.jdk21}/lib/openjdk

  echo "Exporting android auto emulator libraries"
   export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.libcxx pkgs.libcxxrt pkgs.gtk3 pkgs.gst_all_1.gstreamer pkgs.gst_all_1.gstreamermm pkgs.libunwind ]}:$LD_LIBRARY_PATH"
    export PKG_CONFIG_PATH="${pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" [ pkgs.gst_all_1.gstreamer pkgs.gst_all_1.gst-plugins-base pkgs.libunwind pkgs.gtk3 ]}:$PKG_CONFIG_PATH"

  ''+
          pkgs.lib.concatStrings (map (x: ''echo "${x.name}: ${x.description}";'') aliases);



  ####################################################################
  # Without  this, almost  everything  fails with  locale issues  when
  # using `nix-shell --pure` (at least on NixOS).
  # See
  # + https://github.com/NixOS/nix/issues/318#issuecomment-52986702
  # + http://lists.linuxfromscratch.org/pipermail/lfs-support/2004-June/023900.html
  ####################################################################

  LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
}

# vim: set tabstop=2 shiftwidth=2 expandtab:

