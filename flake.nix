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

            package = mkOption {
              type = types.package;
              default = self.packages.${pkgs.system}.default;
              description = "The podkunnect package to use for the service.";
            };
          };

          config = mkIf cfg.enable {
            systemd.services.podkunnect = {
              description = "Podkunnect Service";
              wantedBy = [ "multi-user.target" ];
              after = [ "network.target" ];

              serviceConfig = {
                ExecStart = ''${cfg.package}/bin/podkunnect --name "${cfg.name}" --server "${cfg.server}"'';
                Restart = "on-failure";
                DynamicUser = true;
              };
            };
          };
        };
    };
}