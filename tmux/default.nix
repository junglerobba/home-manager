{ pkgs, ... }:
let
  popup = pkgs.writeShellApplication {
    name = "tmux-popup";
    runtimeInputs = [ pkgs.tmux ];
    text = builtins.readFile ./popup.sh;
  };
in {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "screen-256color";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";

    plugins = with pkgs.tmuxPlugins; [ yank ];

    extraConfig = ''
      set -g status-style 'bg=default fg=default'
      set -g status-left-length 25
      set -g status-left '#{=20:session_name} / '
      set -g window-status-current-format '#[italics][#{window_index}:#{pane_current_command}]'
      set -g status-right-length 100
      set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,} #{=21:pane_title} %a %F %T"

      bind -r C-f display-popup -E "tms"
      bind -r f display-popup -E "tms switch"
      bind -r - run-shell "${popup}/bin/tmux-popup"
      bind -r * confirm -p "Kill session?" "run-shell \"tms kill\""

      bind -r v split-window -h -c "#{pane_current_path}"
      bind -r s split-window -v -c "#{pane_current_path}"

      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      bind -r C-h resize-pane -L
      bind -r C-j resize-pane -D
      bind -r C-k resize-pane -U
      bind -r C-l resize-pane -R

      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
    '';
  };
}
