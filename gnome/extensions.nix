{ pkgs, desktop, ... }:
with pkgs;
lib.optionals (desktop == "gnome") (
  with gnomeExtensions;
  [
    clipboard-indicator
    night-theme-switcher
    wiggle
  ]
)
