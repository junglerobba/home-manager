{
  description = "Home Manager configuration";

  inputs = {
    # TODO move back to unstable once tmux 3.7c builds
    nixpkgs.url = "github:nixos/nixpkgs?ref=a831408e6378bc02ebf8cc09b52c96ca86f6bab4";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tms.url = "github:jrmoulton/tmux-sessionizer";
    coffee-break = {
      url = "github:junglerobba/coffee-break";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jj.url = "github:junglerobba/jj/push-soyrunnvtxot";
    diffsoup = {
      url = "github:junglerobba/diffsoup";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix.url = "github:helix-editor/helix";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      overlays = [
      ]
      ++ (import ./overlays.nix);

      args =
        {
          username,
          homedir,
          desktop ? null,
          darwin ? false,
          isNixOs ? false,
        }:
        { pkgs, ... }: {
          imports = [ ./home.nix ];
          _module.args = {
            inherit
              inputs
              username
              homedir
              desktop
              darwin
              isNixOs
              ;
            isLinux = pkgs.stdenv.hostPlatform.isLinux;
            isMac = pkgs.stdenv.hostPlatform.isDarwin;
          };
        };
    in
    {
      overlays.default = nixpkgs.lib.composeManyExtensions overlays;

      homeModules.default = args;

      darwinModules.default = { username }: {
        nixpkgs.overlays = [ self.overlays.default ];
        imports = [
          ./darwin
          inputs.home-manager.darwinModules.home-manager
        ];
        users.users.${username} = {
          name = username;
          home = "/Users/${username}";
        };
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = args {
            inherit username;
            desktop = null;
            homedir = "/Users/${username}";
            darwin = true;
          };
        };
        _module.args = { inherit username; };
      };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            lua-language-server
          ];
        };

        checks = {
          home =
            (inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                (args {
                  username = "test";
                  homedir = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/test" else "/home/test";
                })
              ];
            }).activationPackage;
        };
      }
    );
}
