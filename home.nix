{ pkgs, ... }: {
  home.username = "junglerobba";
  home.homeDirectory = "/var/home/junglerobba";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    distrobox
    ffmpeg
    lm_sensors
    neofetch
    nixfmt
    ranger
    speedtest-cli
    yt-dlp
  ];

  programs.fish = {
    enable = true;

    shellInit = ''
      set -e NIX_PATH
      export DIRENV_LOG_FORMAT=""
    '';
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
    };
  };

  programs.direnv = { enable = true; };
  programs.htop = {
    enable = true;
    settings = {
      tree_view = true;
      hide_userland_threads = true;
      highlight_base_name = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "Tobias Langendorf";
    userEmail = "junglerobba@jngl.one";
    signing = { key = "063BB04D11363703"; };
    extraConfig = {
      commit.verbose = true;
      pull.rebase = true;
      rebase.autostash = true;
      init.defaultBranch = "main";
    };
    aliases = {
      ignore = "update-index --assume-unchanged";
      unignore = "update-index --no-assume-unchanged";
      ignored = "!git ls-files -v | grep ^[[:lower:]]";
    };
    ignores = [ "shell.nix" ".envrc" ];
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    pinentryFlavor = "tty";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-surround;
        config = "lua require 'nvim-surround'.setup()";
      }
      {
        plugin = nvim-autopairs;
        config = "lua require 'nvim-autopairs'.setup()";
      }
    ];

    extraConfig = ''
      set number
      set wrap
      set autoindent
      set smartindent
      syntax
      filetype plugin on

      set mouse=a

      set incsearch
      set showmatch
      set hlsearch
    '';
  };
}
