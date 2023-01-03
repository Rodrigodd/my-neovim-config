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
                        return table.getn(self.finder.results) + 3
                    end
                }
            }
        }
    }
}
require("telescope").load_extension("ui-select")


local u = require('utils')

local tsb = require 'telescope.builtin'
u.map('n', '<leader>fr', tsb.resume)
u.map('n', '<leader>ff', tsb.find_files)
u.map('n', '<leader>fg', tsb.live_grep)
u.map('n', '<leader>fb', tsb.buffers)
u.map('n', '<leader>fh', tsb.help_tags)
u.map('n', '<leader>fd', function() tsb.diagnostics { severity_limit = 'info' } end)
