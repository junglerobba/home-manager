{
  lib,
  pkgs,
  ...
}:
let
  aliases = {
    closest_bookmark = rev: "closest_bookmark(${rev})";
    tip = rev: "tip(${rev})";
    jira_ticket_id = description: "jira_ticket_id(${description})";
  };
in
{
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
        "M" = "exactly(coalesce(@ & merges(), heads(reachable(@, mutable()) & merges())), 1)";
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
          "@-"
          "-d"
        ];
        rba = [
          "rebase"
          "-s"
          "roots(T..@) ~ immutable()"
          "-d"
          "T"
        ];
      };
      template-aliases = with aliases; {
        "${jira_ticket_id "description"}" = ''
          description.match(regex:"^\\b[A-Z][A-Z0-9_]+-[1-9][0-9]*")
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
        git_push_bookmark = ''
          if(
            jira_ticket_id(description).len() > 0,
            concat(
              "feature/",
              jira_ticket_id(description)
            ),
            concat(
              "push-",
              change_id.short()
            )
          )
        '';
      };
    };
  };
}
