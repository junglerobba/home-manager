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

        cmd-1 = "workspace 1";
        cmd-2 = "workspace 2";
        cmd-3 = "workspace 3";
        cmd-4 = "workspace 4";
        cmd-5 = "workspace 5";
        cmd-6 = "workspace 6";
        cmd-7 = "workspace 7";
        cmd-8 = "workspace 8";
        cmd-9 = "workspace 9";
        cmd-0 = "workspace 10";
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

        cmd-period = "focus-monitor next";
        cmd-comma = "focus-monitor prev";

        cmd-shift-period = "move-workspace-to-monitor next";
        cmd-shift-comma = "move-workspace-to-monitor prev";

        alt-w = "layout h_tiles h_accordion";
      };

      workspace-to-monitor-force-assignment =
        let
          assign =
            assignment: indexes:
            builtins.listToAttrs (
              builtins.map (index: {
                name = index;
                value = assignment;
              }) indexes
            );
        in
        assign "main" [
          "1"
          "2"
          "3"
          "4"
        ]
        // assign "built-in" [
          "9"
          "10"
        ];

      on-window-detected =
        let
          assign = workspace: condition: {
            "if" = condition;
            run = [ "move-node-to-workspace ${workspace}" ];
          };
        in
        [
          (assign "1" { app-id = "org.alacritty"; })
          (assign "2" { app-id = "com.jetbrains.intellij"; })
          (assign "5" { app-id = "com.postmanlabs.mac"; })
          (assign "6" { app-id = "com.google.Chrome"; })
          (assign "6" { app-id = "com.apple.Safari"; })
          (assign "7" { app-id = "org.mozilla.firefox"; })
          (assign "7" { app-id = "org.mozilla.firefoxdeveloperedition"; })
          (assign "9" { app-id = "com.spotify.client"; })
          (assign "9" { app-name-regex-substring = "spotify"; })
          (assign "10" { app-id = "com.hnc.Discord"; })
          (assign "10" { app-id = "com.tinyspeck.slackmacgap"; })
        ];
    };

  };
}
