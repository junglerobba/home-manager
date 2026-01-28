vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4

vim.opt.signcolumn = "yes"

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true
vim.opt.winborder = "solid"

vim.opt.scrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.swapfile = false

vim.cmd([[
    set listchars=tab:→\ ,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:·
]])

vim.opt.list = true

vim.keymap.set('n', "<space>", "<nop>")
vim.g.mapleader = " "

vim.cmd('colorscheme default')

vim.diagnostic.config({
    virtual_text = true,
})

table.toString = function(value)
    local output = ""
    for i = 1, #value do
        output = output .. value[i]
    end
    return output
end


-- keymap
vim.keymap.set({ 'n', 'v' }, '[q', function()
    require("trouble").prev()
end)
vim.keymap.set({ 'n', 'v' }, ']q', function()
    require("trouble").next()
end)
