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
                set -l inspect (${podman}/bin/podman machine inspect)
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
                set -l socket (${podman}/bin/podman system info | ${_yq} -r '.host.remoteSocket.path')
              ''
          )
          ''
            export DOCKER_HOST="unix://$socket"
            export DOCKER_BUILDKIT=0
          ''
        ];

      # from https://gist.github.com/hroi/d0dc0e95221af858ee129fd66251897e
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
        jj log --ignore-working-copy --no-graph --color always -r @ -T '
            surround(
                " (",
                ")",
                separate(
                    " ",
                    bookmarks.join(", "),
                    coalesce(
                        surround(
                            "\"",
                            "\"",
                            if(
                                description.first_line().substr(0, 24).starts_with(description.first_line()),
                                description.first_line().substr(0, 24),
                                description.first_line().substr(0, 23) ++ "…"
                            )
                        ),
                        "(no description set)"
                    ),
                    change_id.shortest(),
                    commit_id.shortest(),
                    if(conflict, "(conflict)"),
                    if(empty, "(empty)"),
                    if(divergent, "(divergent)"),
                    if(hidden, "(hidden)"),
                )
            )
        '
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
