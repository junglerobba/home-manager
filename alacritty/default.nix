{ lib, desktop, ... }:
lib.mkIf (desktop == "sway") {
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = { family = "jetbrains mono"; };
        size = 10;
        offset.y = 5;
      };
    };
  };
}
