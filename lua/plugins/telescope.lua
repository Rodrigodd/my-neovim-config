-- Telescope
telescope = require('telescope')
local lga_actions = require("telescope-live-grep-args.actions")
telescope.setup {
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
        },
        live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {         -- extend mappings
                i = {
                    ["<C-k>"] = lga_actions.quote_prompt(),
                    ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
        },
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
        undo = {
            vim_diff_opts = {
                ctxlen = 5,
            },
        }
    }
}
telescope.load_extension("ui-select")
telescope.load_extension('live_grep_args')
telescope.load_extension('fzf')
telescope.load_extension("undo")

local tsb = require 'telescope.builtin'
vim.keymap.set('n', '<leader>fr', tsb.resume)
vim.keymap.set('n', '<leader>ff', tsb.find_files)
-- vim.keymap.set('n', '<leader>fg', tsb.live_grep)
vim.keymap.set('n', '<leader>fg', telescope.extensions.live_grep_args.live_grep_args)
vim.keymap.set('n', '<leader>fb', tsb.buffers)
vim.keymap.set('n', '<leader>fe', tsb.buffers) -- easier to type than fb
vim.keymap.set('n', '<leader>fh', tsb.help_tags)
vim.keymap.set('n', '<leader>fd', function() tsb.diagnostics { severity_limit = 'info' } end)
vim.keymap.set('n', '<leader>fu', telescope.extensions.undo.undo)
