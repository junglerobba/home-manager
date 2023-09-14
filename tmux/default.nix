{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    extraConfig = ''
      set -ga terminal-overrides ",screen-256color*:Tc"
      set-option -g default-terminal "screen-256color"

      set -g status-style 'bg=default fg=default'
      set -g status-left-length 25
      set -g status-left '#{=20:session_name} / '
      set -g window-status-current-format '#[italics][#{window_index}:#{pane_current_command}]'
      set -g status-right-length 100
      set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,} #{=21:pane_title} %a %F %T"

      bind-key -r C-f display-popup -E "tms"
      bind-key -r f display-popup -E "tms switch"

      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R
    '';
  };
}
