{
  pkgs,
  lib,
  isMac,
  ...
}:
lib.mkIf isMac {

  launchd.agents.unnaturalscrollwheels = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.unnaturalscrollwheels}/Applications/UnnaturalScrollWheels.app/Contents/MacOS/UnnaturalScrollWheels"
      ];
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      RunAtLoad = true;
    };
  };

  targets.darwin.currentHostDefaults = {
    "com.theron.UnnaturalScrollWheels" = {
      LaunchAtLogin = 0;
      ShowMenuBarIcon = 0;
    };
  };
}
