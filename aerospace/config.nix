{
  pkgs,
  lib,
  alacritty,
}:
let
  aerospace-workspace = lib.getExe (
    pkgs.stdenv.mkDerivation {
      name = "aerospace-workspace";
      propagatedBuildInputs = [ pkgs.python3 ];
      dontUnpack = true;
      installPhase = "install -Dm755 ${./scripts/workspace.py} $out/bin/aerospace-workspace";
      meta.mainProgram = "aerospace-workspace";
    }
  );
in
{
  config-version = 2;
  on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
  focus-follows-mouse.enabled = true;

  gaps.inner = {
    horizontal = 5;
    vertical = 5;
  };

  gaps.outer = {
    left = 5;
    right = 5;
    top = 5;
    bottom = 5;
  };

  accordion-padding = 15;

  mode.main.binding = {
    cmd-h = "focus left --boundaries all-monitors-outer-frame";
    cmd-j = "focus down --boundaries all-monitors-outer-frame";
    cmd-k = "focus up --boundaries all-monitors-outer-frame";
    cmd-l = "focus right --boundaries all-monitors-outer-frame";
    cmd-shift-h = "move left --boundaries all-monitors-outer-frame";
    cmd-shift-j = "move down --boundaries all-monitors-outer-frame";
    cmd-shift-k = "move up --boundaries all-monitors-outer-frame";
    cmd-shift-l = "move right --boundaries all-monitors-outer-frame";

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
    alt-shift-1 = "exec-and-forget ${aerospace-workspace} 1 --move";
    alt-shift-2 = "exec-and-forget ${aerospace-workspace} 2 --move";
    alt-shift-3 = "exec-and-forget ${aerospace-workspace} 3 --move";
    alt-shift-4 = "exec-and-forget ${aerospace-workspace} 4 --move";
    alt-shift-5 = "exec-and-forget ${aerospace-workspace} 5 --move";
    alt-shift-6 = "exec-and-forget ${aerospace-workspace} 6 --move";
    alt-shift-7 = "exec-and-forget ${aerospace-workspace} 7 --move";
    alt-shift-8 = "exec-and-forget ${aerospace-workspace} 8 --move";
    alt-shift-9 = "exec-and-forget ${aerospace-workspace} 9 --move";
    alt-shift-0 = "exec-and-forget ${aerospace-workspace} 10 --move";

    cmd-period = "focus-monitor next";
    cmd-comma = "focus-monitor prev";
    cmd-shift-comma = [
      "move-workspace-to-monitor prev"
    ];
    cmd-shift-period = [
      "move-workspace-to-monitor next"
    ];

    cmd-m = [ ];

    alt-w = "layout h_tiles h_accordion";

    cmd-enter = "exec-and-forget ${lib.getExe alacritty}";
  };

  on-window-detected =
    let
      assign = workspace: condition: {
        "if" = condition;
        run = [
          "exec-and-forget ${aerospace-workspace} ${workspace} --move --window $AEROSPACE_WINDOW_ID"
        ];
      };
    in
    [
      (assign "2" { app-id = "com.jetbrains.intellij"; })
      (assign "3" { app-id = "com.microsoft.Outlook"; })
      (assign "3" { app-id = "com.apple.mail"; })
      (assign "5" { app-id = "com.postmanlabs.mac"; })
      (assign "5" { app-id = "com.usebruno.app"; })
      (assign "6" { app-id = "com.google.Chrome"; })
      (assign "6" { app-id = "com.apple.Safari"; })
      (assign "7" { app-id = "org.mozilla.firefox"; })
      (assign "7" { app-id = "org.mozilla.firefoxdeveloperedition"; })
      (assign "9" { app-id = "com.spotify.client"; })
      (assign "9" { app-name-regex-substring = "spotify"; })
      (assign "9" { app-name-regex-substring = "Deezer"; })
      (assign "10" { app-id = "com.hnc.Discord"; })
      (assign "10" { app-id = "com.tinyspeck.slackmacgap"; })
    ];
}
