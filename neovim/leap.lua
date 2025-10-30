vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("LeapSetup", { clear = true }),
    pattern = "*",
    callback = function()
        local function setup()
            vim.keymap.set('n', '<CR>', function()
                print('--- LEAP ---')
                require('leap').leap({
                    windows = { vim.api.nvim_get_current_win() },
                    inclusive = true,
                })
                print('')
            end, { buffer = true })
        end
        if vim.bo.buftype == "" or vim.bo.buftype == "help" then
            setup()
        end
    end
})
