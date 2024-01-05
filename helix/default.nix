{ pkgs, ... }: {
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
          space.F = "file_picker_in_current_buffer_directory";
          space.W = ":lsp-workspace-command";
        };
      };
    };

    languages = {
      language-server.typescript-language-server = with pkgs.nodePackages; {
        command =
          "${typescript-language-server}/bin/typescript-language-server";
      };
      language-server.vscode-html-language-server = with pkgs.nodePackages; {
        command =
          "${vscode-langservers-extracted}/bin/vscode-html-language-server";
      };
      language-server.vscode-css-language-server = with pkgs.nodePackages; {
        command =
          "${vscode-langservers-extracted}/bin/vscode-css-language-server";
      };
      language-server.vscode-json-language-server = with pkgs.nodePackages; {
        command =
          "${vscode-langservers-extracted}/bin/vscode-json-language-server";
      };
      language-server.eslint = with pkgs.nodePackages; {
        command =
          "${vscode-langservers-extracted}/bin/vscode-eslint-language-server";
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
      # TODO: angular language-server not packaged yet
      language-server.angular = with pkgs; {
        command = pkgs.nodePackages."@angular/cli" + "/bin/ngserver";
        scope = "source.angular";
        roots = [ "angular.json" ];
        args = [
          "--stdio"
          "--tsProbeLocations"
          "${nodePackages.typescript}/lib/node_modules"
          "--ngProbeLocations"
          (pkgs.nodePackages."@angular/cli" + "/lib/node_modules")
        ];
        file-types = [ "ts" "html" ];
      };
      language-server.nil = with pkgs; { command = "${nil}/bin/nil"; };
      language-server.bash-language-server = with pkgs.nodePackages; {
        command = "${bash-language-server}/bin/bash-language-server";
      };
      language-server.yaml-language-server = with pkgs; {
        command = "${yaml-language-server}/bin/yaml-language-server";
      };

      language = [
        (with pkgs.nodePackages; {
          name = "typescript";
          auto-format = true;
          language-servers =
            [ "typescript-language-server" "angular" "eslint" "emmet-ls" ];
          formatter = {
            command = "${prettier}/bin/prettier";
            args = [ "--parser" "typescript" ];
          };
        })
        (with pkgs.nodePackages; {
          name = "html";
          language-servers =
            [ "vscode-html-language-server" "angular" "eslint" "emmet-ls" ];
          formatter = {
            command = "${prettier}/bin/prettier";
            args = [ "--parser" "angular" ];
          };
        })
        (with pkgs.nodePackages; {
          name = "css";
          language-servers = [ "vscode-css-language-server" "emmet-ls" ];
          formatter = {
            command = "${prettier}/bin/prettier";
            args = [ "--parser" "css" ];
          };
        })
        (with pkgs.nodePackages; {
          name = "scss";
          language-servers = [ "vscode-css-language-server" "emmet-ls" ];
          formatter = {
            command = "${prettier}/bin/prettier";
            args = [ "--parser" "css" ];
          };
        })
        (with pkgs.nodePackages; {
          name = "json";
          auto-format = false;
          language-servers = [ "vscode-json-language-server" ];
          formatter = {
            command = "${prettier}/bin/prettier";
            args = [ "--parser" "json" ];
          };
        })
        (with pkgs; {
          name = "nix";
          formatter = { command = "${nixfmt}/bin/nixfmt"; };
        })
      ];
    };
  };
}
