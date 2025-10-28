local conform = require('conform')
conform.setup({
    default_format_opts = {
        lsp_format = "fallback",
    },
    formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },
        nix = { "nixfmt" },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Format before save",
    pattern = "*",
    group = vim.api.nvim_create_augroup("FormatConfig", { clear = true }),
    callback = function(ev)
        local conform_opts = { bufnr = ev.buf, lsp_format = "fallback", timeout_ms = 2000 }
        local client = vim.lsp.get_clients({ name = "ts_ls", bufnr = ev.buf })[1]

        if not client then
            conform.format(conform_opts)
            return
        end

        local request_result = client:request_sync("workspace/executeCommand", {
            command = "_typescript.organizeImports",
            arguments = { vim.api.nvim_buf_get_name(ev.buf) },
        })

        if request_result and request_result.err then
            vim.notify(request_result.err.message, vim.log.levels.ERROR)
            return
        end

        conform.format(conform_opts)
    end,
})
