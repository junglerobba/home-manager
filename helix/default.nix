{ pkgs, helix, ... }: {
  programs.helix = {
    enable = true;
    defaultEditor = true;

    package = helix.packages."x86_64-linux".default;

    settings = {

      theme = "gruvbox";

      editor = {
        auto-save = true;
        line-number = "relative";
        cursorline = true;
        completion-trigger-len = 1;
        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "file-modification-indicator"
          ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "version-control"
          ];
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
        cursor-shape = {
          insert = "bar";
        };
        file-picker = {
          hidden = false;
        };
        whitespace = {
          render = {
            space = "all";
            tab = "all";
            newline = "none";
          };
        };
        soft-wrap = {
          enable = true;
        };
      };
      keys = {
        normal = {
          space.F = "file_picker_in_current_buffer_directory";
          space.W = ":lsp-workspace-command";
       };
      };
    };
  };

  xdg.configFile."helix/languages.toml".source = ./languages.toml;
}
