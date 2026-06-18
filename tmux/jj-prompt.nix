{
  lib,
  writers,
  jujutsu,
}:
let
  jj = lib.getExe jujutsu;
in
writers.writeFishBin "jj-prompt" ''
  # Are we in a jj repo?
  argparse "pwd=" "c/color=" -- $argv
  if not ${jj} root --repository "$_flag_pwd" --quiet &>/dev/null
      return 1
  end

  set -l branches (${jj} log --repository "$_flag_pwd" --ignore-working-copy --no-graph --color "$_flag_color" -r 'closest_bookmark(@)' -T 'bookmarks.join(", ") ++ "\n"')
  set -l info
  set -l length (count $branches)
  if test $length -gt 1
      set -l length (math $length - 1)
      set -a info "$branches[1]..+$length"
  else if test $length != 0
      set -a info $branches
  end
  set -a info (${jj} log --repository "$pwd" --ignore-working-copy --no-graph --color "$_flag_color" -r @ -T '
      separate(
          " ",
          change_id.shortest(),
          if(conflict, "(conflict)"),
          if(empty, "(empty)"),
          if(divergent, "(divergent)"),
          if(hidden, "(hidden)"),
      )
  ')
  echo " ($(string join ' ' $info))"
''
