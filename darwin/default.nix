{
  pkgs,
  lib,
  username,
  ...
}:
{

  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    extraOptions =
      ''
        experimental-features = nix-command flakes
      ''
      + lib.optionalString (pkgs.system == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
    settings = {
      auto-optimise-store = false;
      trusted-users = [
        "@admin"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    alacritty
    gimp
    maccy
  ];

  imports = [
    ./dark-mode.nix
    ./system.nix
    ./aerospace.nix
  ];

  system.primaryUser = username;
  system.stateVersion = 6;

  programs.fish = {
    enable = true;
  };
}
