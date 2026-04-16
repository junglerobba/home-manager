{
  pkgs,
  lib,
  darwin,
  isMac,
  ...
}:
let
  config = import ./config.nix {
    inherit lib;
    alacritty = pkgs.alacritty;
  };
in
lib.mkIf (isMac && !darwin) {
  xdg.configFile."aerospace/aerospace.toml".source =
    (pkgs.formats.toml { }).generate "aerospace"
      config;
}
