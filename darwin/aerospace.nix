{
  pkgs,
  lib,
  ...
}:
let
  settings = import ../aerospace/config.nix {
    inherit lib;
    alacritty = pkgs.alacritty;
  };
in
{
  services.aerospace = {
    enable = true;
    inherit settings;
  };
}
