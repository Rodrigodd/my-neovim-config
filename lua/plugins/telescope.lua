-- Telescope
require('telescope').setup {
    defaults = {
        path_display = { "truncate" },
        dynamic_preview_title = true,
        layout_strategy = 'horizontal',
        layout_config = {
            width = 0.95,
        }
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_ivy {
                layout_config = {
                    height = function(self, max_columns, max_lines)
                        return #self.finder.results + 3
                    end
                },
                cache_picker = false,
            }
        }
    }
}
require("telescope").load_extension("ui-select")

local tsb = require 'telescope.builtin'
vim.keymap.set('n', '<leader>fr', tsb.resume)
vim.keymap.set('n', '<leader>ff', tsb.find_files)
vim.keymap.set('n', '<leader>fg', tsb.live_grep)
vim.keymap.set('n', '<leader>fb', tsb.buffers)
vim.keymap.set('n', '<leader>fh', tsb.help_tags)
vim.keymap.set('n', '<leader>fd', function() tsb.diagnostics { severity_limit = 'info' } end)
