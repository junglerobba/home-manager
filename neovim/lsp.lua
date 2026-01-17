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
        vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, opts("Rename Symbol"))
        vim.keymap.set({ 'n', 'v' }, '<space>a', vim.lsp.buf.code_action, opts("Code Action"))
        vim.keymap.set({ 'n' }, '<leader>D', function() require("trouble").open("diagnostics") end)
        vim.keymap.set({ 'n' }, '<leader>S', function() require("trouble").open("symbols") end)
        vim.keymap.set({ 'n', 'v' }, 'grr', function() require("trouble").open("lsp_references") end)
        vim.keymap.set({ 'n', 'v' }, 'grt', function() require("trouble").open("lsp_type_definitions") end)
        vim.keymap.set({ 'n', 'v' }, 'gri', function() require("trouble").open("lsp_implementations") end)
        vim.keymap.set({ 'n', 'v' }, 'grd', function() require("trouble").open("lsp_definitions") end)
        vim.keymap.set('n', '<leader><leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts("Format Buffer"))
    end,
})

local function setup_lsps()
    local enabled = {}
    local lsps_file = vim.fn.expand("$HOME/.config/nvim/lsps")
    local file = io.open(lsps_file, 'r')
    if file then
        for line in file:lines() do
            local trimmed = line:match("^%s*(.-)%s*$")
            if trimmed ~= "" then
                table.insert(enabled, trimmed)
            end
        end
        file:close()
    end
    for _, lsp in pairs(enabled) do
        vim.lsp.config(lsp, {})
    end
    vim.lsp.enable(enabled)
end
setup_lsps()
