vim.g.neoterm_size = tostring(0.3 * vim.o.columns)
vim.g.neoterm_default_mod = 'botright vertical'
vim.g.neoterm_autoscroll = 1
vim.keymap.set('n', '<leader>t', vim.cmd.Ttoggle)
