## Nix config

### NixOS

Example usage:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    config.url = "github:junglerobba/home-manager";
  };

  outputs = { nixpkgs, config, ... }:
    let
      system = "x86_64-linux";
      home-config = config.packages.${system}.module {
        username = "junglerobba";
        homedir = "/home";
      };
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
          {
            home-manager = home-config // {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
        ];
      };
    };
}
```

### Standalone

Example usage:

```nix
{
  inputs = {
    config.url = "github:junglerobba/home-manager";
  };

  outputs = { config, ... }:
    let
      system = "x86_64-linux";
      username = "junglerobba";
    in {
      homeConfigurations.${username} = config.packages.${system}.default {
        inherit username;
        homedir = "/home";
      };
    };
}
```

```bash
nix run home-manager/master -- switch
```

### nix-darwin

Example usage:

```nix
{
  inputs = {
    config.url = "github:junglerobba/home-manager";
  };

  outputs = { config, ... }:
    let
      system = "aarch64-darwin";
      username = "junglerobba";
    in {
      darwinConfigurations.${username} = config.packages.${system}.darwin {
        inherit username;
        # this needs to be set on the first setup in order to have a linux builder available
        # after that, nix-rosetta-builder can take over
        bootstrap = true;
      };
    };
}
```

```bash
sudo nix run nix-darwin/master#darwin-rebuild switch --flake .
```
