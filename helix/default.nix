{ pkgs, ... }:
let
  prettier = parser: {
    command = "prettier";
    args = [ "--parser" parser ];
  };
in {
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
        statusline = {
          left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
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
        cursor-shape = { insert = "bar"; };
        file-picker = { hidden = false; };
        whitespace = {
          render = {
            space = "all";
            tab = "all";
            newline = "none";
          };
        };
        soft-wrap = { enable = true; };
      };
      keys = {

        normal = {
          V = [ "extend_to_line_bounds" "select_mode" ];
          space = {
            F = "file_picker_in_current_buffer_directory";
            W = ":lsp-workspace-command";
            g = [ ":new" ":insert-output git status --porcelain" ];
          };
        };
        select = {
          J = [ "extend_line_down" "extend_to_line_bounds" ];
          K = [ "extend_line_up" "extend_to_line_bounds" ];
        };
      };
    };

    languages = {
      language-server.eslint = {
        command = "vscode-eslint-language-server";
        args = [ "--stdio" ];
        config = {
          validate = "on";
          experimental = { useFlatConfig = false; };
          rulesCustomizations = [ ];
          run = "onType";
          problems = { shortenToSingleLine = false; };
          nodePath = "";
          quiet = false;
          format = { enable = false; };
          codeAction = {
            disableRuleComment = {
              enable = true;
              location = "separateLine";
            };
            showDocumentation = { enable = true; };
          };
        };
      };

      language-server.emmet-ls = with pkgs; {
        command = "${emmet-ls}/bin/emmet-ls";
        args = [ "--stdio" ];
      };

      language-server.angular = {
        command = "ngserver";
        args = [ "--stdio" ];
        scope = "source.angular";
        roots = [ "angular.json" ];
        file-types = [ "ts" "html" ];
      };

      language-server.tailwindcss = {
        command = "tailwindcss-language-server";
        args = [ "--stdio" ];
      };

      language-server.nil = with pkgs; { command = "${nil}/bin/nil"; };

      language-server.bash-language-server = with pkgs.nodePackages; {
        command = "${bash-language-server}/bin/bash-language-server";
      };

      language-server.yaml-language-server = with pkgs; {
        command = "${yaml-language-server}/bin/yaml-language-server";
      };

      language-server.docker-langserver = with pkgs; {
        command = "${dockerfile-language-server-nodejs}/bin/docker-langserver";
      };

      language-server.taplo = with pkgs; { command = "${taplo}/bin/taplo"; };

      language = [
        {
          name = "typescript";
          auto-format = true;
          language-servers =
            [ "typescript-language-server" "angular" "eslint" "emmet-ls" ];
          formatter = prettier "typescript";
        }
        {
          name = "html";
          language-servers = [
            "angular"
            "vscode-html-language-server"
            "tailwindcss"
            "eslint"
            "emmet-ls"
          ];
          formatter = prettier "angular";
        }
        {
          name = "css";
          language-servers = [ "vscode-css-language-server" "emmet-ls" ];
          formatter = prettier "css";
        }
        {
          name = "scss";
          language-servers = [ "vscode-css-language-server" "emmet-ls" ];
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
          formatter = { command = "${pkgs.nixfmt}/bin/nixfmt"; };
        }
      ];
    };
  };
}
