{ lib, pkgs, isNixOs, ... }:
let
  modifier = "Mod4";
  fonts = {
    names = [ "jetbrains mono" ];
    size = 10.0;
  };
in {
  wayland.windowManager.sway = {
    enable = isNixOs;

    config = with pkgs; {
      inherit modifier fonts;

      terminal = "${alacritty}/bin/alacritty";
      menu = "${rofi-wayland}/bin/rofi -show run";

      bars = [{
        inherit fonts;
        position = "top";
        statusCommand = "${i3status-rust}/bin/i3status-rs config-default.toml";
        trayOutput = "*";

      }];

      window = { titlebar = false; };

      defaultWorkspace = "workspace number 1";
      workspaceAutoBackAndForth = true;

      seat."*" = {
        hide_cursor = "60000";
        xcursor_theme = "Adwaita 24";
        shortcuts_inhibitor = "disable";
      };
      input = {
        "type:pointer" = { accel_profile = "flat"; };
        "type:keyboard" = {
          xkb_numlock = "enabled";
          xkb_layout = "us";
          xkb_options = "caps:escape,compose:ralt";
        };
      };

      keybindings = let
        inherit modifier;
        wpctl = "${wireplumber}/bin/wpctl";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
      in lib.mkOptionDefault {
        "XF86AudioMute" = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioLowerVolume" =
          "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%-";
        "XF86AudioRaiseVolume" =
          "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%+ --limit 1.0";
        "XF86AudioMicMute" =
          "exec ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

        "XF86AudioPlay" = "exec ${playerctl} play-pause";
        "XF86AudioNext" = "exec ${playerctl} next";
        "XF86AudioPrev" = "exec ${playerctl} previous";
        "XF86AudioStop" = "exec ${playerctl} stop";

        "Print" = let
          screenshot = writeShellApplication {
            name = "screenshot";
            runtimeInputs = [ grim slurp wl-clipboard ];
            text = builtins.readFile ./screenshot.sh;
          };
        in "exec ${screenshot}/bin/screenshot";

        "${modifier}+period" = "focus output right";
        "${modifier}+comma" = "focus output left";
        "${modifier}+Shift+period" = "move workspace to output right";
        "${modifier}+Shift+comma" = "move workspace to output left";

        "${modifier}+s" = "sticky toggle";
      };
      startup = [{ command = "${mako}/bin/mako"; }];

      output."*".adaptive_sync = "on";
    };

    extraConfig = ''
      include ~/.config/sway/config.d/*
    '';

    systemd = { xdgAutostart = true; };

    wrapperFeatures = {
      base = true;
      gtk = true;
    };

  };

  programs.i3status-rust = { enable = isNixOs; };
}