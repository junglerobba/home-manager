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
        auto-optimise-store = true
        experimental-features = nix-command flakes
      ''
      + lib.optionalString (pkgs.system == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
    settings.trusted-users = [
      "@admin"
    ];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    gimp
  ];

  imports = [
    ./dark-mode.nix
    ./system.nix
  ];

  system.primaryUser = username;
  system.stateVersion = 6;
}
