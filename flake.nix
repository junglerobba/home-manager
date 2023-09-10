{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { nixpkgs, home-manager, helix, ... }:
    let arch = "x86_64-linux";
    in {
      defaultPackage.${arch} = home-manager.defaultPackage.${arch};

      homeConfigurations.junglerobba =
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${arch};
          extraSpecialArgs = { inherit helix; };
          modules = [ ./home.nix ];
        };
    };
}
