local mc = require('multicursor-nvim')
mc.setup()

vim.keymap.set('n', 'ga', mc.addCursorOperator)
vim.keymap.set('x', 'S', mc.matchCursors)
vim.keymap.set('x', 'I', mc.insertVisual)

mc.addKeymapLayer(function(layer)
    layer('n', ',', function()
        if not mc.cursorsEnabled() then
            mc.enableCursors()
        else
            mc.clearCursors()
        end
    end)
end)
