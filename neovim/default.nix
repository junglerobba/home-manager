{
  pkgs,
  lib,
  ...
}:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = lib.fileContents ./init.lua;

    extraPackages = with pkgs; [
      ripgrep
      emmet-ls
      bash-language-server
      nixd
      yaml-language-server
      taplo
      dockerfile-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      cmp-nvim-lsp
      nvim-lspconfig
      lsp_signature-nvim
      vim-colorschemes
      nvim-treesitter.withAllGrammars
      {
        plugin = oil-nvim;
        type = "lua";
        config = lib.fileContents ./oil.lua;
      }
      {
        plugin = auto-save-nvim;
        type = "lua";
        config = ''
          require('auto-save').setup()
        '';
      }
      {
        plugin = todo-comments-nvim;
        type = "lua";
        config = ''
          require('todo-comments').setup()
        '';
      }
      {
        plugin = mini-nvim;
        type = "lua";
        config = lib.fileContents ./mini.lua;
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = lib.fileContents ./cmp.lua;
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = lib.fileContents ./lsp.lua;
      }
      {
        plugin = nvim-treesitter-context;
        type = "lua";
        config = ''
          require('treesitter-context').setup()
        '';
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = lib.fileContents ./gitsigns.lua;
      }
    ];
  };
}
