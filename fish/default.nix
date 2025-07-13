{
  isMac,
  lib,
  pkgs,
  ...
}:
{
  programs.fish = {
    enable = true;
    functions = {
      fish_greeting = "";
      fish_prompt = ''
        set -l last_pipestatus $pipestatus
        set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
        set -l normal (set_color normal)
        set -q fish_color_status
        or set -g fish_color_status red

        # Color the prompt differently when we're root
        set -l color_cwd $fish_color_cwd
        set -l suffix '>'
        if functions -q fish_is_root_user; and fish_is_root_user
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            end
            set suffix '#'
        end

        # Write pipestatus
        # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
        set -l bold_flag --bold
        set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
        if test $__fish_prompt_status_generation = $status_generation
            set bold_flag
        end
        set __fish_prompt_status_generation $status_generation
        set -l status_color (set_color $fish_color_status)
        set -l statusb_color (set_color $bold_flag $fish_color_status)
        set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

        echo -n -s (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status " " $suffix " "
      '';

      podman-docker-sock =
        with pkgs;
        let
          _jq = "${jq}/bin/jq";
          _yq = "${yq-go}/bin/yq";
        in
        lib.concatStringsSep "\n" [
          (
            if isMac then
              ''
                set -l inspect (podman machine inspect 2>/dev/null || return 1)
                set -l state (echo $inspect | ${_jq} -r '.[0].State')
                if test "$state" != running
                  return 1
                end
                set -l socket (echo $inspect | ${_jq} -r '.[0].ConnectionInfo.PodmanSocket.Path')
              ''
            else
              ''
                if not type -q podman
                  return 1
                end
                set -l socket (podman system info | ${_yq} -r '.host.remoteSocket.path')
              ''
          )
          ''
            export DOCKER_HOST="unix://$socket"
            export DOCKER_BUILDKIT=0
          ''
        ];

      # adapted from https://gist.github.com/hroi/d0dc0e95221af858ee129fd66251897e
      fish_jj_prompt = ''
        # Is jj installed?
        if not command -sq jj
            return 1
        end

        # Are we in a jj repo?
        if not jj root --quiet &>/dev/null
            return 1
        end

        # Generate prompt
        set -l branches (jj log --ignore-working-copy --no-graph --color always -r 'closest_bookmark(@)' -T 'bookmarks.join(", ") ++ "\n"')
        set -l info
        set -l length (count $branches)
        if test $length -gt 1
            set -l length (math $length - 1)
            set -a info "$branches[1]..+$length"
        else if test $length != 0
            set -a info $branches
        end
        set -a info (jj log --ignore-working-copy --no-graph --color always -r @ -T '
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
      '';

      fish_vcs_prompt = ''
        fish_jj_prompt $argv
        or fish_git_prompt $argv
        or fish_hg_prompt $argv
        or fish_fossil_prompt $argv
      '';
    };

    shellInit = ''
      podman-docker-sock
    '';
  };
}
