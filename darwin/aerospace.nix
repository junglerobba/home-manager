{
  ...
}:
{
  services.aerospace = {
    enable = true;
    settings = {
      mode.main.binding = {
        cmd-h = "focus left --boundaries all-monitors-outer-frame";
        cmd-j = "focus down --boundaries all-monitors-outer-frame";
        cmd-k = "focus up --boundaries all-monitors-outer-frame";
        cmd-l = "focus right --boundaries all-monitors-outer-frame";
        cmd-shift-h = "move left";
        cmd-shift-j = "move down";
        cmd-shift-k = "move up";
        cmd-shift-l = "move right";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";
        alt-0 = "workspace 10";
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";
        alt-shift-0 = "move-node-to-workspace 10";

        alt-period = "focus-monitor next";
        alt-comma = "focus-monitor prev";

        alt-shift-period = "move-workspace-to-monitor next";
        alt-shift-comma = "move-workspace-to-monitor prev";
      };
    };
  };
}
