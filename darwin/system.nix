{
  ...
}:
{
  system = {

    defaults = {
      controlcenter = {
        Bluetooth = true;
        NowPlaying = true;
        Sound = true;
      };
      dock = {
        autohide = true;
        # Whether to automatically rearrange spaces based on most recent use
        mru-spaces = false;
        show-recents = false;
        persistent-others = [
          "/Applications/Nix Apps"
        ];
        # helpful for aerospace stability
        expose-group-apps = true;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        ShowPathbar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 1; # 0 = When space allows 1 = Always 2 = Never
        ShowSeconds = true;
      };
      WindowManager = {
        EnableStandardClickToShowDesktop = false;
      };
      NSGlobalDomain = {
        AppleInterfaceStyleSwitchesAutomatically = true;
        NSWindowShouldDragOnGesture = true;
      };
      ActivityMonitor = {
        ShowCategory = 101; # All Processes, Hierarchally
      };
      screencapture.target = "clipboard";
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
