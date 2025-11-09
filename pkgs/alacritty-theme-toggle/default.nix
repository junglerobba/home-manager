{
  writeShellScript,
}:
writeShellScript "alacritty-theme-toggle" ''
  ALACRITTY_TARGET="''${HOME}/.config/alacritty/theme.toml"
  HELIX_TARGET="''${HOME}/.config/helix/themes/adaptive.toml"
  VIM_THEME_TARGET="''${HOME}/.config/nvim/theme"
  if [ "$DARKMODE" -eq "1" ]; then
    ln -sf ${../../alacritty/themes/dark.toml} "''${ALACRITTY_TARGET}"
    ln -sf ${../../helix/themes/dark.toml} "''${HELIX_TARGET}"
    echo dark > "''${VIM_THEME_TARGET}"
  else
    ln -sf ${../../alacritty/themes/light.toml} "''${ALACRITTY_TARGET}"
    ln -sf ${../../helix/themes/light.toml} "''${HELIX_TARGET}"
    echo light > "''${VIM_THEME_TARGET}"
  fi

  pkill -USR1 hx
''
