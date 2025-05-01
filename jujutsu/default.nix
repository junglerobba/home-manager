{ ... }:
let
  aliases = {
    closest_bookmark = rev: "closest_bookmark(${rev})";
    tip = rev: "tip(${rev})";
  };
in
{
  programs.jujutsu = {
    enable = true;
    settings = {
      ui = {
        default-command = "log";
      };
      revset-aliases = with aliases; {
        "${closest_bookmark "to"}" = "heads(::to & bookmarks())";
        "${tip "branch"}" = "heads(::branch & ~empty() & ~description(exact:\"\"))";
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
      };
    };
  };
}
