require('mini.ai').setup()        -- a/i textobjects
require('mini.align').setup()     -- aligning
require('mini.bracketed').setup() -- unimpaired bindings with TS
require('mini.comment').setup()   -- TS-wise comments
require('mini.jump').setup()      -- fFtT work past a line
require('mini.pairs').setup()     -- pair brackets
require('mini.surround').setup({  -- surround
    custom_surroundings = {
        ['l'] = { output = { left = '[', right = ']()' } }
    }
})
local miniclue = require('mini.clue')
miniclue.setup({ -- cute prompts about bindings
    triggers = {
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },
        { mode = 'n', keys = '<space>' },
        { mode = 'x', keys = '<space>' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },

        -- Bracketed
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },
    },
    clues = {
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
    },
})

local picker = require('mini.pick')
local extras = require('mini.extra')
picker.setup({
    options = {
        content_from_bottom = true,
    },
    mappings = {
        send_to_qflist = {
            char = '<C-q>',
            func = function()
                local items = picker.get_picker_matches().all
                local query = table.toString(picker.get_picker_query())
                local qf_items = {}

                for _, item in ipairs(items) do
                    local entry = {}
                    if type(item) == "string" then
                        local path, lnum, col, rest = item:match("^([^%z]+)%z(%d+)%z(%d+)%z(.*)$")
                        if not path then
                            path = item:match("^([^:%z]+)$")
                        end

                        if path then
                            entry.filename = path
                            entry.lnum = tonumber(lnum) or 1
                            entry.col = tonumber(col) or 1
                            if rest then
                                entry.text = rest
                            end
                        end
                    else
                        goto continue
                    end

                    table.insert(qf_items, entry)
                    ::continue::
                end

                if #qf_items > 0 then
                    vim.fn.setqflist({}, ' ', {
                        items = qf_items,
                        title = "Query: " .. query,
                    })
                    picker.stop()
                    vim.cmd('copen')
                end
            end,
        },
    },
})
extras.setup()

vim.keymap.set('n', '<leader>f', picker.builtin.files)
vim.keymap.set('n', '<leader>b', picker.builtin.buffers)
vim.keymap.set('n', '<leader>/', picker.builtin.grep_live)
vim.keymap.set('n', '<leader>g', function()
    extras.pickers.git_files({
        scope = "modified",
    })
end
)
vim.keymap.set('n', "<leader>'", picker.builtin.resume)
