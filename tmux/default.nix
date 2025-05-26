{ pkgs, isMac, ... }:
with pkgs;
{
  programs.tmux = {
    enable = true;
    shell = "${fish}/bin/fish";
    terminal = "xterm-256color";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";

    plugins = with tmuxPlugins; [ yank ];

    extraConfig =
      let
        status-right =
          let
            coffee-status = writeShellApplication {
              name = "coffee-status";
              text = builtins.readFile ./coffee-status.sh;
            };
          in
          lib.concatStrings (
            [
              (
                let
                  config = (formats.yaml { }).generate "gitmux-conf" {
                    tmux = {
                      symbols.branch = "";
                      layout = [
                        "branch"
                        "remote-branch"
                        "divergence"
                        " "
                        "flags"
                      ];
                    };
                  };
                in
                "#(${gitmux}/bin/gitmux -cfg ${config} #{pane_current_path}) "
              )
              " %a %F %T"
            ]
            ++ lib.optionals isMac [
              "#(${coffee-status}/bin/coffee-status)"
            ]
          );
        popup = writeShellApplication {
          name = "tmux-popup";
          runtimeInputs = [ tmux ];
          text = builtins.readFile ./popup.sh;
        };
        kill = writeShellApplication {
          name = "tmux-kill-session";
          runtimeInputs = [
            tmux
            tmux-sessionizer
          ];
          text = builtins.readFile ./kill.sh;
        };
      in
      ''
        set -g status-style 'bg=default fg=default'
        set -g status-left-length 25
        set -g status-left '#{=20:session_name} / '
        set -g window-status-current-format '#[bold][#{window_index}:#{pane_current_command}]'
        set -g status-right-length 100
        set -g status-right "${status-right}"
        bind C-f display-popup -E "tms"
        bind f display-popup -E "tms switch"
        bind - run-shell "${popup}/bin/tmux-popup"
        bind * confirm -p "Kill session?" "run-shell \"${kill}/bin/tmux-kill-session\""

        bind v split-window -h -c "#{pane_current_path}"
        bind s split-window -v -c "#{pane_current_path}"

        bind -n M-h select-pane -L
        bind -n M-j select-pane -D
        bind -n M-k select-pane -U
        bind -n M-l select-pane -R

        bind -r C-h resize-pane -L
        bind -r C-j resize-pane -D
        bind -r C-k resize-pane -U
        bind -r C-l resize-pane -R

        bind P switch-client -l

      ''
      + (
        let
          tms-config = "TMS_CONFIG_FILE=$HOME/.cache/tms/marks.toml";
        in
        ''
          bind h run-shell "${tms-config} tms marks 0"
          bind j run-shell "${tms-config} tms marks 1"
          bind k run-shell "${tms-config} tms marks 2"
          bind l run-shell "${tms-config} tms marks 3"
          bind H run-shell "${tms-config} tms marks set 0"
          bind J run-shell "${tms-config} tms marks set 1"
          bind K run-shell "${tms-config} tms marks set 2"
          bind L run-shell "${tms-config} tms marks set 3"

        ''
      )
      + ''
        bind q set-option status

        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
      '';
  };
}
