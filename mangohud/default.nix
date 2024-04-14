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
    };
  };
}
