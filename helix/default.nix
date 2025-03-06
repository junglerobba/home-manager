{ pkgs, isMac, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    themes = {
      ayu_custom = {
        inherits = "ayu_dark";
        "ui.virtual.inlay-hint" = {
          fg = "gray";
          bg = "background";
          modifiers = [ "dim" ];
        };
      };
    };

    settings = {
      theme = "ayu_custom";
      editor = {
        auto-save = {
          focus-lost = true;
          after-delay.enable = true;
        };
        line-number = "relative";
        rulers = [ 80 ];
        cursorline = true;
        completion-trigger-len = 1;
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
        cursor-shape.insert = "bar";
        file-picker.hidden = false;
        whitespace = {
          render = {
            space = "all";
            tab = "all";
            newline = "none";
          };
        };
        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "warning";
        soft-wrap.enable = true;
      };
      keys = {
        normal = {
          ret = "goto_word";
          V = [
            "extend_to_line_bounds"
            "select_mode"
          ];
        };
        select = {
          J = [
            "extend_line_down"
            "extend_to_line_bounds"
          ];
          K = [
            "extend_line_up"
            "extend_to_line_bounds"
          ];
        };
      };
    };

    languages = with pkgs; {
      language-server.emmet-ls = {
        command = "${emmet-ls}/bin/emmet-ls";
        args = [ "--stdio" ];
      };

      language-server.angular = {
        args = [ "--stdio" ];
      };

      language-server.nixd.command = "${nixd}/bin/nixd";

      language-server.bash-language-server.command = "${bash-language-server}/bin/bash-language-server";

      language-server.yaml-language-server.command = "${yaml-language-server}/bin/yaml-language-server";

      language-server.docker-langserver.command = "${dockerfile-language-server-nodejs}/bin/docker-langserver";

      language-server.taplo.command = "${taplo}/bin/taplo";

      language-server.rust-analyzer = {
        config = {
          check.command = "clippy";
        };
      };

      language =
        let
          prettier = parser: {
            command = "prettier";
            args = [
              "--parser"
              parser
            ];
          };
        in
        [
          {
            name = "typescript";
            auto-format = true;
            language-servers = [
              "typescript-language-server"
              "angular"
              "vscode-eslint-language-server"
              "emmet-ls"
            ];
            formatter = prettier "typescript";
          }
          {
            name = "html";
            language-servers = [
              "angular"
              "vscode-html-language-server"
              "tailwindcss-ls"
              "vscode-eslint-language-server"
              "emmet-ls"
            ];
            formatter = prettier "angular";
          }
          {
            name = "css";
            language-servers = [
              "vscode-css-language-server"
              "emmet-ls"
            ];
            formatter = prettier "css";
          }
          {
            name = "scss";
            language-servers = [
              "vscode-css-language-server"
              "emmet-ls"
            ];
            formatter = prettier "css";
          }
          {
            name = "json";
            auto-format = false;
            language-servers = [ "vscode-json-language-server" ];
            formatter = prettier "json";
          }
          {
            name = "nix";
            formatter.command = "${nixfmt-rfc-style}/bin/nixfmt";
          }
        ];
    };
  };
}
