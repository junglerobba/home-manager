{ pkgs, ... }:
with pkgs;
let
  blame = writeShellApplication {
    name = "blame";
    text = builtins.readFile ./git-blame.sh;
  };
  yazi = lib.getExe pkgs.yazi;
in
{
  # make sure helix themes directory exists
  xdg.configFile."helix/themes/.keep".source = pkgs.writeText "" "";

  programs.helix = {
    enable = true;

    settings = {
      theme = "adaptive";
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
        rainbow-brackets = true;
      };
      keys =
        let
          vim = {
            "0" = "goto_line_start";
            "$" = "goto_line_end";
            "^" = "goto_first_nonwhitespace";
          };
        in
        {
          normal = {
            ret = "goto_word";
            V = [
              "extend_to_line_bounds"
              "select_mode"
            ];
            B = ":echo %sh{${blame}/bin/blame %{cursor_line} %{buffer_name}}";
            space.f = "file_picker_in_current_directory";
            space.F = "file_picker";
            space.l = ":reflow";
            space.space.f = ":format";
            space.space.g = ":reset-diff-change";
            space.e =
              let
                tmp = "/tmp/hx-yazi";
              in
              [
                ":sh > ${tmp}"
                ":set mouse false"
                ":insert-output ${yazi} %{buffer_name} --chooser-file=${tmp}"
                ":redraw"
                ":set mouse true"
                ":open ${tmp}"
                "select_all"
                "split_selection_on_newline"
                "goto_file"
                ":buffer-close! ${tmp}"
              ];
          }
          // vim;
          select = {
            J = [
              "extend_line_down"
              "extend_to_line_bounds"
            ];
            K = [
              "extend_line_up"
              "extend_to_line_bounds"
            ];
          }
          // vim;
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

      language-server.docker-langserver.command = "${dockerfile-language-server}/bin/docker-langserver";

      language-server.taplo.command = "${taplo}/bin/taplo";

      language-server.rust-analyzer = {
        config = {
          check.command = "clippy";
        };
      };

      language-server.kotlin = {
        command = "${kotlin-lsp}/bin/kotlin-lsp";
        args = [ "--stdio" ];
        file-types = [ "kotlin" ];
        roots = [
          "build.gradle"
          "build.gradle.kts"
          "pom.xml"
        ];
      };

      language =
        let
          prettier = parser: {
            command = "npx";
            args = [
              "prettier"
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
            auto-format = true;
          }
          {
            name = "kotlin";
            language-servers = [ "kotlin" ];
          }
        ];
    };
  };
}
