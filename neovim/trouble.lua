require("trouble").setup({
    auto_preview = false,
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
