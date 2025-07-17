{
  lib,
  pkgs,
  ...
}:
let
  aliases = {
    closest_bookmark = rev: "closest_bookmark(${rev})";
    tip = rev: "tip(${rev})";
    gerrit_change_id = change_id: "gerrit_change_id(${change_id})";
  };
in
{
  xdg.configFile."fish/completions/jj.fish".source =
    pkgs.runCommand "jj.fish"
      {
        nativeBuildInputs = [
          pkgs.jujutsu
        ];
      }
      ''
        COMPLETE=fish jj > $out
      '';
  programs.jujutsu = {
    enable = true;
    settings = {
      ui = {
        default-command = "log";
        diff-formatter = [
          (lib.getExe pkgs.difftastic)
          "--color=always"
          "$left"
          "$right"
        ];
      };
      git = {
        write-change-id-header = true;
        track-default-bookmark-on-clone = false;
      };
      revset-aliases = with aliases; {
        "${closest_bookmark "to"}" = "heads(::to & bookmarks())";
        "${tip "branch"}" = "heads(::branch & ~empty() & ~description(exact:\"\"))";
        "T" = "trunk()";
      };
      aliases = with aliases; {
        tug = [
          "bookmark"
          "move"
          "--from"
          (closest_bookmark "@-")
          "--to"
          (tip "@")
        ];
        nn = [
          "new"
          "--no-edit"
          "-r"
        ];
        l = [
          "log"
          "-r"
          "::@"
        ];
        add-parent = [
          "rebase"
          "-s"
          "@"
          "-d"
          "all:@-"
          "-d"
        ];
      };
      template-aliases = with aliases; {
        "${gerrit_change_id "change_id"}" = ''
          "Change-Id: I6a6a6964" ++ change_id.normal_hex()
        '';
      };
      templates = {
        draft_commit_description = ''
          concat(
            coalesce(description, "\n"),
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\nJJ: ignore-rest\n",
            diff.git(),
          )
        '';
        commit_trailers = ''
          if(
            config("gerrit.enabled").as_boolean(),
            gerrit_change_id(change_id)
          )
        '';
      };
      # only exists to override
      gerrit.enabled = false;
    };
  };
}
