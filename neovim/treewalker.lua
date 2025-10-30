require('treewalker').setup({
    select = true,
    jumplist = 'left',
})
vim.keymap.set({ 'n', 'v' }, '<M-n>', "<cmd>Treewalker Down<cr>", { silent = true })
vim.keymap.set({ 'n', 'v' }, '<M-p>', "<cmd>Treewalker Up<cr>", { silent = true })
vim.keymap.set({ 'n', 'v' }, '<M-i>', "<cmd>Treewalker Right<cr>", { silent = true })
vim.keymap.set({ 'n', 'v' }, '<M-o>', "<cmd>Treewalker Left<cr>", { silent = true })
