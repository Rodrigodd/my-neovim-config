return {
    'shiracamus/vim-syntax-x86-objdump-d',
    'nvim-lua/plenary.nvim',
    {
        'Joakker/lua-json5',
        build =
            vim.loop.os_uname().sysname == 'Windows_NT'
            and 'cargo build --release && mv target/release/liblua_json5.dll lua/json5.dll && cargo clean'
            or './install.sh',
    },
    {
        'Apeiros-46B/qalc.nvim',
        config = function()
            require('qalc').setup {}
        end,
    },
    {
        'numToStr/Comment.nvim',
        opts = {},
        lazy = false,
    },
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter' },
        config = function()
            require('treesj').setup({
                use_default_keymaps = false,
            })
            vim.keymap.set("n", "gS", "<cmd>TSJSplit<CR>", { desc = "Split syntax node in multiple lines" })
            vim.keymap.set("n", "gJ", "<cmd>TSJJoin<CR>", { desc = "Joint syntax node in a single lines" })
        end,
    },
    {
        'cshuaimin/ssr.nvim',
        config = function()
            require("ssr").setup {
                min_width = 50,
                min_height = 5,
                max_width = 120,
                max_height = 25,
                keymaps = {
                    close = "q",
                    next_match = "n",
                    prev_match = "N",
                    replace_confirm = "<cr>",
                    replace_all = "<leader><cr>",
                },
            }
            vim.keymap.set({ "n", "x" }, "<leader>sr", function() require("ssr").open() end)
        end
    },
    {
        'anuvyklack/hydra.nvim',
        lazy = true,
        keys = {
            "<leader>gd",
        },
        config = function()
            vim.keymap.del({ 'o', 'x', 'n' }, '[%', {})
            vim.keymap.del({ 'o', 'x', 'n' }, ']%', {})

            local Hydra = require('hydra')
            Hydra({
                -- name = "Navigate diagnostics",
                mode = 'n',
                body = '<leader>gd',
                config = {
                    -- hint = false,
                    color = 'pink',
                },
                heads = {
                    { 'n', vim.diagnostic.goto_next },
                    { 'N', vim.diagnostic.goto_prev },
                },
            })
        end,
    },
    {
        'echasnovski/mini.align',
        version = '*',
        opts = {}
    },
    {
        'nmac427/guess-indent.nvim',
        config = function()
            require('guess-indent').setup {
                filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
                    "netrw",
                    "tutor",
                    "make"
                },
            }
        end,
    },
    {
        "kylechui/nvim-surround",
        config = function()
            require('plugins.surround')
        end
    },
    {
        'windwp/nvim-autopairs',
        enable = false,
        config = function()
            local npairs = require('nvim-autopairs');
            npairs.setup {
                disable_filetype = { "TelescopePrompt" },
                disable_in_macro = false, -- disable when recording or executing a macro
                ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
                enable_moveright = true,
                enable_afterquote = true,         -- add bracket pairs after quote
                enable_check_bracket_line = true, --- check bracket in same line
                check_ts = true,
                map_bs = true,                    -- map the <BS> key
                map_c_w = false,                  -- map <c-w> to delete a pair if possible
                fast_wrap = {
                    map = '<M-e>',
                },
            }
            -- local Rule = require('nvim-autopairs.rule')
            -- npairs.remove_rule('{')
            -- npairs.add_rules {
            --     Rule('{', '}')
            --         :end_wise(function () return true end),
            -- }
        end
    },
    {
        'ggandor/leap.nvim',
        config = function()
            require 'leap'.add_default_mappings()
            -- require 'leap'.init_highlight(true)
        end
    },
    -- UI to select things (files, grep results, open buffers...)
    {
        'nvim-telescope/telescope.nvim',
        version = '^1.0.0',
        dependencies = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
            { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build =
                'rm -rf build && cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
            },
            "debugloop/telescope-undo.nvim",
        },
        config = function()
            require('plugins.telescope')
        end,
    },
    'marko-cerovac/material.nvim',
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        opts = {
            disable_background = true,
            disable_float_background = false,
            disable_italics = true,
        }
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {
            scope = {
                include = {
                    node_type = {
                        python = { "if_statement", "for_statement", "while_statement", "function_definition", "try_statement", "with_statement" },
                    }
                }
            }
        },
    },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/playground',
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
        config = function()
            require 'plugins.treesitter'
        end
    },
    {
        'SmiteshP/nvim-navic',
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require 'plugins.navic'
        end
    },
    {
        'jandamm/cryoline.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
        config = function() require 'myline' end,
    },
    {
        'lewis6991/gitsigns.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require 'gitsigns'.setup()
        end
    },
    {
        'MunifTanjim/exrc.nvim',
        config = function()
            vim.o.exrc = false
            require("exrc").setup({
                files = {
                    ".nvimrc.lua",
                },
            })
        end
    },
    {
        "barreiroleo/ltex-extra.nvim",
        before = 'mason.nvim'
    },
    {
        'williamboman/mason.nvim',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'nvim-lua/lsp-status.nvim',
            'neovim/nvim-lspconfig',
            'ray-x/lsp_signature.nvim',

            'akinsho/flutter-tools.nvim',
            'neovim/nvim-lspconfig',
            'nvim-telescope/telescope.nvim',
            'SmiteshP/nvim-navic',
        },
        config = function()
            require('plugins.lsp')
        end
    },
    {
        'L3MON4D3/LuaSnip',
        version = "v2.*",
        config = function()
            require('plugins.snips')
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'saadparwaiz1/cmp_luasnip',
            -- 'L3MON4D3/LuaSnip'
        },
        config = function()
            require('plugins.nvimcmp')
        end
    },
    {
        'zbirenbaum/copilot.lua',
        opts = {
            panel = {
                enabled = true,
                auto_refresh = false,
                keymap = {
                    jump_prev = "[[",
                    jump_next = "]]",
                    accept = "<CR>",
                    refresh = "gr",
                    open = "<M-i>"
                },
                layout = {
                    position = "bottom", -- | top | left | right
                    ratio = 0.4
                },
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = "<M-k>",
                    accept_word = '<M-l>',
                    accept_line = '<M-j>',
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
            },
            filetypes = {
                python = true,
                rust = true,
                c = true,
                cpp = true,
                yaml = true,
                markdown = true,
                help = false,
                gitcommit = true,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
            copilot_node_command = 'node', -- Node.js version must be > 16.x
            server_opts_overrides = {},
        }
    },
    {
        'yetone/avante.nvim',
        event = "VeryLazy",
        version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
        opts = {
            provider = "copilot",
            behaviour = {
                auto_suggestions = false, -- Experimental stage
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
            -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
            "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua",        -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        -- use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim"
        },
        config = function()
            require('plugins.neotree')
        end
    },

    -- dap
    { "mfussenegger/nvim-dap" },

    { 'sakhnik/nvim-gdb' },

    -- rust plugins
    'cespare/vim-toml',
    'ron-rs/ron.vim',
    {
        'vxpm/ferris.nvim',
        before = 'mason.nvim',
        opts = {
            create_commands = true,
        },
    },
    {
        'saecki/crates.nvim',
        tag = 'v0.3.0',
        event = { "BufRead Cargo.toml" },
        dependencies = { 'nvim-lua/plenary.nvim' },
        after = 'nvim-cmp',
        config = function()
            require('crates').setup()
            vim.api.nvim_create_autocmd("BufRead", {
                group = vim.api.nvim_create_augroup('CmpSourceCargo', { clear = true }),
                pattern = "Cargo.toml",
                callback = function()
                    require('cmp').setup.buffer {
                        sources = { { name = 'crates' } }
                    }
                end
            })
        end,
    },

    'elkowar/yuck.vim',

    -- flutter plugins
    'dart-lang/dart-vim-plugin',
    { 'akinsho/flutter-tools.nvim', dependencies = 'nvim-lua/plenary.nvim' },

    -- java plugins
    'mfussenegger/nvim-jdtls',

    -- {
    --     "vhyrro/luarocks.nvim",
    --     priority = 1000,
    --     config = true,
    --     opts = {
    --         rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }
    --     }
    --
    -- },
    -- {
    --     "rest-nvim/rest.nvim",
    --     ft = "http",
    --     dependencies = { "luarocks.nvim" },
    --     config = function()
    --         require("rest-nvim").setup {
    --             keybinds = {
    --                 {
    --                     "<localleader>rr", "<cmd>Rest run<cr>", "Run request under the cursor",
    --                 },
    --                 {
    --                     "<localleader>rl", "<cmd>Rest run last<cr>", "Re-run latest request",
    --                 },
    --             }
    --         }
    --     end,
    -- }
}
