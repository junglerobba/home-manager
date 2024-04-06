{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tms = {
      url = "github:jrmoulton/tmux-sessionizer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixgl, flake-utils, home-manager, tms, helix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nixgl.overlay ];
        };
        isMac = pkgs.stdenv.hostPlatform.isDarwin;
        isLinux = pkgs.stdenv.hostPlatform.isLinux;
        nixGLPrefix = "${nixgl.packages.${system}.nixGLIntel}/bin/nixGLIntel ${
            nixgl.packages.${system}.nixVulkanIntel
          }/bin/nixVulkanIntel";
        nixGL = import ./nixgl.nix {
          inherit pkgs;
          config = { inherit nixGLPrefix; };
        };
      in {
        defaultPackage = { username, homedir }:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit nixGL tms helix username homedir system isMac isLinux;
            };
            modules = [ ./home.nix ];
          };
      });

}
