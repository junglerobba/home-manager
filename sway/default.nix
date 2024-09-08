{
  lib,
  pkgs,
  desktop,
  ...
}:
let
  modifier = "Mod4";
  fonts = {
    names = [ "jetbrains mono" ];
    size = 10.0;
  };
  terminal = "${pkgs.alacritty}/bin/alacritty";
  swaylockCommand = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
in
lib.mkIf (desktop == "sway") {
  wayland.windowManager.sway = {
    enable = true;

    config = with pkgs; {
      inherit modifier fonts terminal;

      menu = "${rofi-wayland}/bin/rofi -show drun";

      bars = [
        {
          inherit fonts;
          position = "top";
          statusCommand = "${i3status-rust}/bin/i3status-rs config-default.toml";
          trayOutput = "*";

        }
      ];

      window = {
        titlebar = false;
      };

      defaultWorkspace = "workspace number 1";
      workspaceAutoBackAndForth = true;

      seat."*" = {
        hide_cursor = "60000";
        xcursor_theme = "Adwaita 24";
        shortcuts_inhibitor = "disable";
      };
      input = {
        "type:pointer" = {
          accel_profile = "flat";
          natural_scroll = "enabled";
        };
        "type:keyboard" = {
          xkb_numlock = "enabled";
          xkb_layout = "us";
          xkb_options = "caps:escape,compose:ralt";
        };
      };

      keybindings =
        let
          inherit modifier;
          wpctl = "${wireplumber}/bin/wpctl";
          playerctl = "${pkgs.playerctl}/bin/playerctl";
          pulsemixer = "${pkgs.pulsemixer}/bin/pulsemixer";
        in
        lib.mkOptionDefault {
          "${modifier}+Escape" = "exec ${swaylockCommand}";

          "XF86AudioMute" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioLowerVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%-";
          "XF86AudioRaiseVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%+ --limit 1.0";
          "XF86AudioMicMute" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

          "XF86AudioPlay" = "exec ${playerctl} play-pause";
          "XF86AudioNext" = "exec ${playerctl} next";
          "XF86AudioPrev" = "exec ${playerctl} previous";
          "XF86AudioStop" = "exec ${playerctl} stop";

          "${modifier}+p" = "exec ${terminal} -e ${pulsemixer}";

          "Print" =
            let
              screenshot = writeShellApplication {
                name = "screenshot";
                runtimeInputs = [
                  grim
                  slurp
                  wl-clipboard
                ];
                text = builtins.readFile ./screenshot.sh;
              };
            in
            "exec ${screenshot}/bin/screenshot";

          "${modifier}+period" = "focus output right";
          "${modifier}+comma" = "focus output left";
          "${modifier}+Shift+period" = "move workspace to output right";
          "${modifier}+Shift+comma" = "move workspace to output left";

          "${modifier}+s" = "sticky toggle";
        };
    };

    extraConfig = ''
      include ~/.config/sway/config.d/*
    '';

    systemd = {
      xdgAutostart = true;
      variables = [
        "--all"
      ];
    };

    wrapperFeatures = {
      base = true;
      gtk = true;
    };

  };

  programs.i3status-rust = {
    enable = true;
    bars.default.blocks = [
      {
        block = "music";
        separator = " / ";
        interface_name_exclude = [ "firefox" ];
      }
      {
        block = "memory";
        format = " $icon $mem_used_percents ";
        format_alt = " $icon $swap_used_percents ";
      }
      {
        block = "cpu";
        interval = 1;
      }
      {
        block = "load";
        format = " $icon $1m ";
        interval = 1;
      }
      { block = "sound"; }
      {
        block = "time";
        format = " $timestamp.datetime(f:'%a %F %T') ";
        interval = 1;
      }
    ];
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "jetbrains mono 12";
  };

  services.mako.enable = true;

  services.wlsunset = {
    enable = true;
    latitude = 51.1;
    longitude = 10.4;
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 600;
        command = swaylockCommand;
      }
      {
        timeout = 600;
        command = "swaymsg 'output * power off'";
        resumeCommand = "swaymsg 'output * power on'";
      }
    ];
  };
}
