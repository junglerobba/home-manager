{ lib, isNixOs, ... }:
lib.mkIf isNixOs {
  dconf.settings = {
    "org/gnome-shell" = {
      enabled-extensions = [ "nightthemeswitcher@romainvigier.fr'" ];
    };
    "org/gnome/desktop/interface" = { enable-hot-corners = true; };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      workspaces-only-on-primary = true;
      attach-modal-dialogs = true;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      natural-scroll = true;
    };
    "org/gnome/desktop/wm/keybindings" = { close = [ "<Shift><Super>q" ]; };
    "org/gnome/desktop/wm/preferences" = { resize-with-right-button = true; };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "lv3:menu_switch" "compose:ralt" ];
    };
    "org/gnome/settings-daemon/plugins/color" = { night-light-enabled = true; };
  };
}