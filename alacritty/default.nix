{ isMac, ... }: {
  programs.alacritty = {
    enable = isMac;
    settings = {
      window = {
        startup_mode = "Maximized";
        padding = {
          x = 5;
          y = 5;
        };
        option_as_alt = "Both";
      };
      font = {
        normal = { family = "jetbrains mono"; };
        size = 13.0;
        offset.y = 5;
      };
    };
  };
}
