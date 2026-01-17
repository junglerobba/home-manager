vim.api.nvim_create_autocmd('FileType', {
    -- automatically enable for supported filetypes
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match) or args.match
        local installed = require('nvim-treesitter').get_installed('parsers')
        if vim.tbl_contains(installed, lang) then
            -- highlighting
            vim.treesitter.start(args.buf)

            -- indentation
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

            -- folds
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo[0][0].foldmethod = 'expr'
        end
    end
})

local textobjects_selections = {
    { "ib", "@block.inner",       "textobjects" },
    { "ab", "@block.outer",       "textobjects" },
    { "if", "@field.inner",       "textobjects" },
    { "af", "@field.outer",       "textobjects" },
    { "iv", "@assignment.rhs",    "textobjects" },
    { "av", "@assignment.outer",  "textobjects" },
    { "ic", "@comment.inner",     "textobjects" },
    { "ac", "@comment.outer",     "textobjects" },
    { "am", "@function.outer",    "textobjects" },
    { "im", "@function.inner",    "textobjects" },
    { "at", "@class.outer",       "textobjects" },
    { "it", "@class.inner",       "textobjects" },
    { "ar", "@return.outer",      "textobjects" },
    { "ir", "@return.inner",      "textobjects" },
    { "ia", "@parameter.inner",   "textobjects" },
    { "aa", "@parameter.outer",   "textobjects" },
    { "ii", "@conditional.inner", "textobjects" },
    { "ai", "@conditional.outer", "textobjects" },
    { "il", "@loop.inner",        "textobjects" },
    { "al", "@loop.outer",        "textobjects" },
    { "ib", "@block.inner",       "textobjects" },
    { "ab", "@block.outer",       "textobjects" },
    { "as", "@local.scope",       "locals" },
}

for _, obj in ipairs(textobjects_selections) do
    vim.keymap.set({ "x", "o" }, obj[1], function()
        require("nvim-treesitter-textobjects.select").select_textobject(obj[2], obj[3])
    end)
end

vim.keymap.set({ "n", "x", "o" }, ";", require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_previous)

local textobjects_moves = {
    { "f", "@field.inner",     "textobjects" },
    { "m", "@function.outer",  "textobjects" },
    { "t", "@class.outer",     "textobjects" },
    { "r", "@return.inner",    "textobjects" },
    { "a", "@parameter.inner", "textobjects" },
    { "b", "@block.outer",     "textobjects" },
    { "c", "@comment.outer",   "textobjects" },
}

for _, obj in ipairs(textobjects_moves) do
    vim.keymap.set({ "n", "x", "o" }, "]" .. obj[1], function()
        require("nvim-treesitter-textobjects.move").goto_next_start(obj[2], obj[3])
    end)
    vim.keymap.set({ "n", "x", "o" }, "[" .. obj[1], function()
        require("nvim-treesitter-textobjects.move").goto_previous_start(obj[2], obj[3])
    end)
end

require('nvim-treesitter-textobjects').setup({
    move = {
        set_jumps = true,
    },
})

require('treesitter-context').setup({})
