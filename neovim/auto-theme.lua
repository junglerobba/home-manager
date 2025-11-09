local watch = vim.fn.expand("$HOME/.config/nvim/theme")

local function handle_os_theme()
    local file = io.open(watch)
    if not file then
        return
    end
    local content = file:read("*line")
    if content ~= "" then
        vim.opt.background = content
    end
    file:close()
end
handle_os_theme()

require("fwatch").watch(watch, {
    on_event = function()
        vim.defer_fn(handle_os_theme, 0)
    end,
})
