{
  lib,
  desktop,
  isMac,
  ...
}:
lib.mkIf (desktop != "gnome") {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = lib.mkIf (!isMac) "None";
        option_as_alt = lib.mkIf isMac "Both";
        padding = {
          x = 5;
          y = 5;
        };
      };
      font = {
        normal = {
          family = if isMac then "monaco" else "jetbrains mono";
        };
        size = 10.6;
        offset.y = 3;
      };
    };
  };
}
