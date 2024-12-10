{
  lib,
  pkgs,
  desktop,
  isNixOs,
  ...
}:
let
  modifier = "Mod4";
  fonts = {
    names = [ "jetbrains mono" ];
    size = 10.0;
  };
  terminal = if isNixOs then "${pkgs.alacritty}/bin/alacritty" else "alacritty";
  swaylockCommand = lib.concatStringsSep " " [
    (if isNixOs then "${pkgs.swaylock}/bin/swaylock" else "swaylock")
    "-f"
    "-c"
    "000000"
  ];
  cliphist = "${pkgs.cliphist}/bin/cliphist";
  rofi = if isNixOs then "${pkgs.rofi-wayland}/bin/rofi" else "rofi";
  nullPkg = pkgs.callPackage ../pkgs/null { };
in
lib.mkIf (desktop == "sway") {
  wayland.windowManager.sway = {
    enable = true;
    package = lib.mkIf (!isNixOs) null;

    xwayland = isNixOs;

    config = with pkgs; {
      inherit modifier fonts terminal;

      menu = "${rofi} -show drun";

      bars = [
        {
          inherit fonts;
          command = lib.mkIf (!isNixOs) "swaybar";
          position = "top";
          statusCommand = "${i3status-rust}/bin/i3status-rs config-default.toml";
          trayOutput = "*";

        }
      ];

      window = {
        titlebar = false;

        commands = [
          {
            criteria.class = ".*";
            command = "inhibit_idle fullscreen";
          }
          {
            criteria.app_id = ".*";
            command = "inhibit_idle fullscreen";
          }
        ];
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
          wpctl = if isNixOs then "${wireplumber}/bin/wpctl" else "wpctl";
          playerctl = "${pkgs.playerctl}/bin/playerctl";
          pulsemixer = "${pkgs.pulsemixer}/bin/pulsemixer";
        in
        lib.mkOptionDefault {
          "${modifier}+Ctrl+q" = "exec ${swaylockCommand}";

          "--locked XF86AudioMute" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "--locked XF86AudioLowerVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%-";
          "--locked XF86AudioRaiseVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%+ --limit 1.0";
          "--locked XF86AudioMicMute" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

          "--locked XF86AudioPlay" = "exec ${playerctl} play-pause";
          "--locked XF86AudioNext" = "exec ${playerctl} next";
          "--locked XF86AudioPrev" = "exec ${playerctl} previous";
          "--locked XF86AudioStop" = "exec ${playerctl} stop";

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

          "${modifier}+Shift+v" =
            let
              rofi-cliphist = writeShellApplication {
                name = "rofi-cliphist";
                runtimeInputs = [
                  cliphist
                  wtype
                ];
                text = builtins.readFile ./rofi-cliphist.sh;
              };
            in
            "exec ${rofi} -show cliphist -modes \"cliphist:${rofi-cliphist}/bin/rofi-cliphist\" -kb-custom-1 \"Ctrl+x\"";

          "${modifier}+delete" =
            let
              powermenu = writeShellApplication {
                name = "powermenu";
                runtimeInputs = lib.optionals isNixOs [
                  rofi-wayland
                ];

                text = builtins.readFile ./powermenu.sh;

              };
            in
            "exec ${powermenu}/bin/powermenu";
        };

      startup = [
        {
          command = "${wl-clipboard}/bin/wl-paste --type text --watch ${cliphist} store";
        }
        { command = "${mako}/bin/mako"; }
      ];
    };

    extraConfig = ''
      include ~/.config/sway/config.d/*
      include /etc/sway/config.d/*
    '';

    systemd = {
      enable = isNixOs;
      xdgAutostart = isNixOs;
      variables = lib.optionals isNixOs [
        "--all"
      ];
    };

    wrapperFeatures = lib.mkIf isNixOs {
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
    package = if isNixOs then pkgs.rofi-wayland else nullPkg;
    font = "jetbrains mono 12";
    theme = "Monokai";
    inherit terminal;

    extraConfig = {
      show-icons = true;
    };
  };

  services.wlsunset = {
    enable = true;
    latitude = 51.1;
    longitude = 10.4;
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = swaylockCommand;
      }
    ];
    timeouts = [
      {
        timeout = 600;
        command = swaylockCommand;
      }
      (
        let
          swaymsg = if isNixOs then "${pkgs.sway}/bin/swaymsg" else "swaymsg";
        in
        {
          timeout = 600;
          command = "${swaymsg} 'output * power off'";
          resumeCommand = "${swaymsg} 'output * power on'";
        }
      )
    ];
  };
}
