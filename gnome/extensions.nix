{ pkgs, desktop, ... }:
with pkgs;
lib.optionals (desktop == "gnome") (with gnomeExtensions; [ night-theme-switcher ])
