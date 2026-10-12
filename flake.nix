{
  description = "A flake for the podkunnect CLI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: import nixpkgs { inherit system; };
    in {
      packages = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in {
          default = pkgs.buildDartApplication {
            pname = "podkunnect";
            version = "unstable";

            # Include the entire repository so relative path dependencies (like podku_shared) are available
            src = builtins.path { path = ./.; name = "source"; };

            # Tell the builder where the main Dart project is located relative to the root
            sourceRoot = "source/src/main/podkunnect";
#            setSourceRoot = ''
#                  tree .
#                  sourceRoot="source/src/main/podkunnect"
#            '';

            # Path to the lockfile relative to the repository root
            autoPubspecLock = ./src/main/podkunnect/pubspec.lock;

            nativeBuildInputs = [ pkgs.pkg-config ];
            buildInputs = [ pkgs.mpv ];
            postFixup = ''
                wrapProgram $out/bin/podkunnect \
                  --prefix LD_LIBRARY_PATH : "${pkgs.mpv}/lib"
              '';
          };
        }
        # The flutter desktop app, linux only
        // nixpkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          podku = pkgs.flutter.buildFlutterApplication rec {
            pname = "podku";
            version = "1.3.5";

            # Include the entire repository so relative path dependencies (podku_shared, podku_client) are available
            src = builtins.path { path = ./.; name = "source"; };
            sourceRoot = "source/src/main/app";

            autoPubspecLock = ./src/main/app/pubspec.lock;

            nativeBuildInputs = [ pkgs.pkg-config pkgs.copyDesktopItems ];
            buildInputs = [ pkgs.mpv-unwrapped ];

            # just_audio plays through libmpv (media_kit), which is loaded at runtime
            extraWrapProgramArgs = ''--prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.mpv-unwrapped ]}"'';

            desktopItems = [
              (pkgs.makeDesktopItem {
                name = "podku";
                desktopName = "Podku";
                comment = "A simple podcast application";
                exec = "podku";
                icon = "podku";
                categories = [ "AudioVideo" "Audio" "Player" ];
                startupWMClass = "com.github.lamarios.podku";
              })
            ];

            postInstall = ''
              install -Dm644 assets/podku-icon.svg $out/share/icons/hicolor/scalable/apps/podku.svg
            '';

            meta = {
              description = "Podku podcast application";
              mainProgram = "podku";
              platforms = pkgs.lib.platforms.linux;
            };
          };
        }
      );

      nixosModules.default = { config, lib, pkgs, ... }:
        with lib;
        let
          cfg = config.services.podkunnect;
        in {
          options.services.podkunnect = {
            enable = mkEnableOption "the podkunnect service";

            name = mkOption {
              type = types.str;
              description = "The name parameter to pass to podkunnect";
              example = "my-podku-node";
            };

            server = mkOption {
              type = types.str;
              description = "The server parameter to pass to podkunnect";
              example = "https://example.com";
            };

            volume = mkOption {
              type = types.int;
              default = 100;
              description = "Default player volume, between 0 and 100 (in %)";
              example = "100";
            };

            package = mkOption {
              type = types.package;
              default = self.packages.${pkgs.system}.default;
              description = "The podkunnect package to use for the service.";
            };
          };

          config = mkIf cfg.enable {
            systemd.user.services.podkunnect = {
              description = "Podkunnect Service";
              wantedBy = [ "default.target" ];
              after = [ "network.target" ];

              serviceConfig = {
                Type = "simple";
                ExecStart = ''${cfg.package}/bin/podkunnect --name "${cfg.name}" --server "${cfg.server}" --volume ${toString cfg.volume}'';

                  # Restart if the server drops or network hiccups occur during boot
                Restart = "always";
                RestartSec = "5s";

                # Audio services need access to system sound hardware
                RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
                SuppressIONice = false;


              };
            };
          };
        };
    };
}