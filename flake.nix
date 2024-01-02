{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tms = {
      url = "github:jrmoulton/tmux-sessionizer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, tms, ... }:
    let arch = "x86_64-linux";
    in {
      defaultPackage.${arch} = home-manager.defaultPackage.${arch};

      homeConfigurations.junglerobba =
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${arch};
          extraSpecialArgs = { inherit tms; };
          modules = [ ./home.nix ];
        };
    };
}
