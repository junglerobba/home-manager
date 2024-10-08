{ pkgs, isMac, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "gruvbox";
      editor = {
        auto-save = true;
        line-number = "relative";
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
          V = [
            "extend_to_line_bounds"
            "select_mode"
          ];
          space = {
            F = "file_picker_in_current_buffer_directory";
            W = ":lsp-workspace-command";
          };
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

      language-server.nil.command = "${nil}/bin/nil";

      language-server.nixd.command = "${nixd}/bin/nixd";

      language-server.bash-language-server.command = "${bash-language-server}/bin/bash-language-server";

      language-server.yaml-language-server.command = "${yaml-language-server}/bin/yaml-language-server";

      language-server.docker-langserver.command = "${dockerfile-language-server-nodejs}/bin/docker-langserver";

      language-server.taplo.command = "${taplo}/bin/taplo";

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
              "eslint"
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
            language-servers = [ "nixd" ];
            formatter.command = "${nixfmt-rfc-style}/bin/nixfmt";
          }
        ];
    };
  };
}
