{ lib, desktop, ... }:
lib.mkIf (desktop != "gnome") {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "None";
        padding = {
          x = 5;
          y = 5;
        };
      };
      font = {
        normal = {
          family = "jetbrains mono";
        };
        size = 10.6;
        offset.y = 3;
      };
    };
  };
}
