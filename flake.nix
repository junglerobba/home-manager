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
  };

  outputs = { nixpkgs, nixgl, flake-utils, home-manager, tms, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        mpv-overlay = (self: super: {
          mpv = if self.stdenv.hostPlatform.isLinux then
            super.mpv.override { scripts = [ self.mpvScripts.mpris ]; }
          else
            super.mpv;
        });
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nixgl.overlay mpv-overlay ];
        };
        nixGLPrefix = "${nixgl.packages.${system}.nixGLIntel}/bin/nixGLIntel ${
            nixgl.packages.${system}.nixVulkanIntel
          }/bin/nixVulkanIntel";
        extraSpecialArgs = { username, homedir, isNixOs, desktop }: {
          inherit pkgs username homedir isNixOs desktop tms system;
          isMac = pkgs.stdenv.hostPlatform.isDarwin;
          isLinux = pkgs.stdenv.hostPlatform.isLinux;
          nixGL = import ./nixgl.nix {
            inherit pkgs;
            config = { nixGLPrefix = if !isNixOs then nixGLPrefix else ""; };
          };
        };
      in {
        defaultPackage = { username, homedir, desktop }:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = extraSpecialArgs {
              inherit username homedir;
              isNixOs = false;
            };
            modules = [ ./home.nix ];
          };
        packages.module = { username, homedir, desktop }: {
          users.${username} = import ./home.nix;
          extraSpecialArgs = extraSpecialArgs {
            inherit username homedir desktop;
            isNixOs = true;
          };
        };
      });

}
