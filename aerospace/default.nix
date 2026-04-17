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
  configFile = (pkgs.formats.toml { }).generate "aerospace.toml" config;
in
lib.mkIf (isMac && !darwin) {
  launchd.agents.aerospace = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"
        "--config-path"
        "${configFile}"
      ];
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      RunAtLoad = true;
    };
  };
}
