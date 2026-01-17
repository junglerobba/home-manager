require('mini.comment').setup()
require('mini.jump').setup()     -- fFtT work past a line
require('mini.pairs').setup()    -- pair brackets
require('mini.surround').setup({ -- surround
    custom_surroundings = {
        ['l'] = { output = { left = '[', right = ']()' } }
    }
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
