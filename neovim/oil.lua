local oil = require('oil')
oil.setup({
    columns = {
        "icon",
        "permissions",
    },
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,
    view_options = {
        show_hidden = true,
    },
})

vim.keymap.set('n', '<leader>e', oil.open)
