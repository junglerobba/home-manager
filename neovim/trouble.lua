require("trouble").setup({
    auto_preview = false,
    auto_refresh = false,
    focus = true,
    follow = false,
    modes = {
        lsp_base = {
            params = {
                include_current = true,
            },
        },
    },
})
