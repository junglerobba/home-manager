local gitsigns = require('gitsigns')
gitsigns.setup({
    current_line_blame = true,
})

vim.keymap.set('n', '[g', function()
    gitsigns.nav_hunk('prev')
end
)
vim.keymap.set('n', ']g', function()
    gitsigns.nav_hunk('next')
end
)
vim.keymap.set('n', '<leader>B', gitsigns.blame)
