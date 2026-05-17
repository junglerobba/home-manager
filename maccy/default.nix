{
  pkgs,
  lib,
  isMac,
  ...
}:
lib.mkIf isMac {

  launchd.agents.maccy = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.maccy}/Applications/Maccy.app/Contents/MacOS/Maccy"
      ];
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      RunAtLoad = true;
    };
  };

  targets.darwin.currentHostDefaults = {
    "org.p0deje.Maccy" = {
      menuIcon = "paperclip";
      pasteByDefault = 1;
    };
  };
}
