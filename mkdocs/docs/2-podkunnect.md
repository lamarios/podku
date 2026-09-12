# Podkunnect

Podkunnect is a cli tool that acts as a player for Podku. Similar to Spotify connect, it allows to transfer the playback
to another device connected to the same Podku server.

## Installation

### NixOS flake

For NixOS users, there's a flake available to make the set up easy.

flake.nix

```nix
podkunnect.url = "github:lamarios/podku";

# ...

nixos = nixos.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            podkunnect.nixosModules.default
            # other modules...
          ];
};
```

configuration.nix

```nix
services.podkunnect = {
    enable = true;
    name = "Kitchen";
    server = "https://your-podku-server-url.com";
    volume = 60; # default volume
  };

```

### Other distributions

Download the latest binaries from the [release page](https://github.com/lamarios/podku/releases/)

## Usage

| flag            | Required | Comment                                            |
|-----------------|----------|----------------------------------------------------|
| `--server` `-s` | Yes      | The Podku server URL                               |
| `--name` `-n`   | Yes      | The player name                                    | 
| `--volume` `-v` | No       | The default volume from 0 to 100 (defaults to 100) |
