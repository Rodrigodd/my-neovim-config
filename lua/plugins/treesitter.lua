require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "toml",
        "rust",
        "lua",
        "markdown",
        "c",
        "vim",
    },
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = false,
        disable = {},
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = false,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["at"] = "@parameter.outer",
                ["it"] = "@parameter.inner",
            },
            selection_modes = {},
            include_surrounding_whitespace = true,
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            node_incremental = "<CR>",
            scope_incremental = "grc",
            node_decremental = "<BS>",
        },
    },
}
