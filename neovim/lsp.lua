vim.keymap.set('n', '<space>d', vim.diagnostic.setloclist, { desc = "Add buffer diagnostics to the location list." })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = function(str)
            return { buffer = ev.buf, desc = str }
        end

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts("Declaration"))
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts("Definition"))
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts("Implementation"))
        vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts("Signature Help"))
        vim.keymap.set('i', '<M-k>', vim.lsp.buf.signature_help, opts("Signature Help"))
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts("Add Workspace Folder"))
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts("Remove Workspace Folder"))
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts("List Workspace Folders"))
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts("Type Definition"))
        vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, opts("Rename Symbol"))
        vim.keymap.set({ 'n', 'v' }, '<space>a', vim.lsp.buf.code_action, opts("Code Action"))
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts("Buffer References"))
        vim.keymap.set('n', '<leader><leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts("Format Buffer"))
    end,
})

local lspconfig = vim.lsp.config

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.code_action({
            async = false,
            apply = true,
            context = {
                only = { "source.organizeImports" },
            },
        })
    end,
})

lspconfig('nixd', {})
lspconfig('rust_analyzer', {})
lspconfig('ts_ls', {})
lspconfig('lua_ls', {})
lspconfig('html', {})
lspconfig('eslint', {})
lspconfig('bashls', {})
lspconfig('angularls', {})
lspconfig('emmet_ls', {})
lspconfig('tinymist', {})
lspconfig('yamlls', {})
lspconfig('taplo', {})
lspconfig('dockerls', {})

vim.lsp.enable({
    "nixd",
    "rust_analyzer",
    "ts_ls",
    "lua_ls",
    "html",
    "eslint",
    "bashls",
    "angularls",
    "emmet_ls",
    "tinymist",
    "yamlls",
    "taplo",
    "dockerls",
})
