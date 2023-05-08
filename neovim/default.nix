{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;

    extraPackages = [ pkgs.ripgrep ];

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
        config = builtins.readFile (./plugins/lsp.lua) + ''

          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          require'lspconfig'.tsserver.setup {
            cmd = {
              '${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server',
              '--stdio'
            },
            capabilities = capabilities
          }
          require'lspconfig'.html.setup {
            cmd = {
              '${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server',
              '--stdio'
            },
            capabilities = capabilities
          }
          require'lspconfig'.cssls.setup {
            cmd = {
              '${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server',
              '--stdio'
            },
            capabilities = capabilities
          }
          require'lspconfig'.eslint.setup {
            cmd = {
              '${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-eslint-language-server',
              '--stdio'
            },
            capabilities = capabilities
          }
        '';
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
      vim-gitgutter
      {
        plugin =
          nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars);
        type = "lua";
        config = builtins.readFile (./plugins/treesitter.lua);
      }
      {
        plugin = nerdtree;
        type = "lua";
        config = builtins.readFile (./plugins/nerdtree.lua);
      }
      vim-vsnip
      cmp-nvim-lsp
      {
        plugin = neoterm;
        type = "lua";
        config = builtins.readFile (./plugins/neoterm.lua);
      }
      auto-save-nvim
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
        plugin = gruvbox-nvim;
        type = "lua";
        config = builtins.readFile (./theme.lua);
      }
    ];

    extraConfig = ''
      lua << EOF
      ${builtins.readFile ./config.lua}
      ${builtins.readFile ./keymap.lua}
      EOF
    '';
  };
}
