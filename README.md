## Nix config

### NixOS

Example usage:

```nix
{
  nixpkgs.overlays = [ config.overlays.default ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = config.homeModules.default {
      inherit username;
      homedir = "/home/${username}";
      desktop = "gnome";
      isNixOs = true;
    };
  };
}
```

### Standalone

Example usage:

```nix
{
  inputs = {
    nixpkgs.follows = "config/nixpkgs";
    home-manager.follows = "config/home-manager";
    config.url = "github:junglerobba/home-manager";
  };

  outputs = { nixpkgs, home-manager, config, ... }:
    let
      system = "x86_64-linux";
      username = "junglerobba";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ config.overlays.default ];
      };
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (config.homeModules.default {
            inherit username;
            homedir = "/home/${username}";
          })
          # other modules
        ];
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
  darwinConfigurations.${username} = nix-darwin.lib.darwinSystem {
    inherit system;
    modules = [
      (config.darwinModules.default { inherit username; })
      # other modules
    ]
  }
}
```

```bash
sudo nix run nix-darwin/master#darwin-rebuild switch --flake .
```
