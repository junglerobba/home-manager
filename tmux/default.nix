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

      set -g status-style 'bg=#333333 fg=#5eacd3'

      bind-key -r C-f display-popup -E "tms"
      bind-key -r f display-popup -E "tms switch"
    '';
  };
}
