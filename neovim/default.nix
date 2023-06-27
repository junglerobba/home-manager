{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;

    extraPackages = [
      pkgs.ripgrep 
      pkgs.shellcheck
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages.bash-language-server
      pkgs.rnix-lsp
      pkgs.wl-clipboard
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-surround;
        config = "lua require 'nvim-surround'.setup()";
      }
      {
        plugin = nvim-autopairs;
        config = "lua require 'nvim-autopairs'.setup()";
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile (./plugins/telescope.lua);
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile (./plugins/lsp.lua);
      }
      {
        plugin = lsp_signature-nvim;
        type = "lua";
        config = builtins.readFile (./plugins/lsp-signature.lua);
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile (./plugins/cmp.lua);
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = builtins.readFile (./plugins/treesitter.lua);
      }
      {
        plugin = nvim-treesitter-context;
        type = "lua";
        config = builtins.readFile (./plugins/treesitter-context.lua);
      }
      {
        plugin = nerdtree;
        type = "lua";
        config = builtins.readFile (./plugins/nerdtree.lua);
      }
      {
        plugin = neoterm;
        type = "lua";
        config = builtins.readFile (./plugins/neoterm.lua);
      }
      {
        plugin = undotree;
        type = "lua";
        config = builtins.readFile (./plugins/undotree.lua);
      }
      {
        plugin = vim-fugitive;
        type = "lua";
        config = builtins.readFile (./plugins/fugitive.lua);
      }
      {
        plugin = comment-nvim;
        type = "lua";
        config = builtins.readFile (./plugins/comment.lua);
      }
      {
        plugin = harpoon;
        type = "lua";
        config = builtins.readFile (./plugins/harpoon.lua);
      }
      {
        plugin = gruvbox-nvim;
        type = "lua";
        config = builtins.readFile (./theme.lua);
      }
      vim-gitgutter
      vim-vsnip
      cmp-nvim-lsp
      auto-save-nvim
    ];

    extraConfig = ''
      lua << EOF
      ${builtins.readFile ./config.lua}
      ${builtins.readFile ./keymap.lua}
      EOF
    '';
  };
}
