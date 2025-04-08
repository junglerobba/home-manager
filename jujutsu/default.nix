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
    };
  };
}
