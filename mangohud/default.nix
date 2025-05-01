{
  pkgs,
  lib,
  isNixOs,
  isLinux,
  ...
}:
lib.mkIf (isNixOs || isLinux) {
  programs.mangohud = {
    enable = true;
    enableSessionWide = isNixOs;
    package = lib.mkIf (!isNixOs) pkgs.null;
    settings = {
      full = true;
      no_display = true;
      media_player = false;
      gamemode = false;
      fps_limit = "0,144,120,90,60,48,30,15";
    };
  };
}
