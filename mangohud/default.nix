{ lib, isNixOs, ... }:
lib.mkIf isNixOs {
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      full = true;
      no_display = true;
      media_player = false;
      gamemode = false;
      fps_limit = "144,120,90,60,48,30,15,0";
    };
  };
}
