-- Telescope
require('telescope').setup {
    defaults = {
        path_display = { "truncate" },
        dynamic_preview_title = true,
        layout_strategy = 'horizontal',
        layout_config = {
            width = 0.95,
        }
    }
}

local u = require('utils')

local tsb = require 'telescope.builtin'
u.map('n', '<leader>ff', tsb.find_files)
u.map('n', '<leader>fg', tsb.live_grep)
u.map('n', '<leader>fb', tsb.buffers)
u.map('n', '<leader>fh', tsb.help_tags)
