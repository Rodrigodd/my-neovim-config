return {
    'wbthomason/packer.nvim', -- Package manager
    'nvim-lua/plenary.nvim',
    {
        'Joakker/lua-json5',
        build = 'cargo build --release && mv target/release/liblua_json5.dll lua/json5.dll && cargo clean',
    },
    'tpope/vim-commentary', -- "gc" to comment visual regions/lines
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
        config = function()
            vim.keymap.del({ 'o', 'x', 'n' }, '[%', {})
            vim.keymap.del({ 'o', 'x', 'n' }, ']%', {})

            local Hydra = require('hydra')
            Hydra({
                -- name = "Navigate diagnostics",
                mode = 'n',
                body = 'g',
                config = {
                    -- hint = false,
                    color = 'pink',
                },
                heads = {
                    { '[', vim.diagnostic.goto_prev },
                    { ']', vim.diagnostic.goto_next },
                },
            })
        end,
    },
    {
        'nmac427/guess-indent.nvim',
        config = function()
            require('guess-indent').setup { auto_cmd = false }
        end,
    },
    {
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                surrounds = {
                    ["g"] = {
                        add = function()
                            local config = require("nvim-surround.config")
                            local result = config.get_input("Enter the struct name: ")
                            if result then
                                return { { result .. "<" }, { ">" } }
                            end
                        end,
                    }
                }
            })
        end
    },
    {
        'windwp/nvim-autopairs',
        config = function()
            local npairs = require('nvim-autopairs');
            npairs.setup {
                disable_filetype = { "TelescopePrompt" },
                disable_in_macro = false, -- disable when recording or executing a macro
                ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
                enable_moveright = true,
                enable_afterquote = true, -- add bracket pairs after quote
                enable_check_bracket_line = true, --- check bracket in same line
                check_ts = true,
                map_bs = true, -- map the <BS> key
                map_c_w = false, -- map <c-w> to delete a pair if possible
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
        dependencies = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim'
        },
        config = function()
            require('plugins.telescope')
        end,
    },
    'marko-cerovac/material.nvim',
    'lukas-reineke/indent-blankline.nvim',
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
        "SmiteshP/nvim-gps",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        after = 'nvim-navic',
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
        name = "lsp_lines",
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            vim.keymap.set(
                "n", "<leader>j",
                function()
                    vim.diagnostic.config({
                        virtual_text = not require('lsp_lines').toggle()
                    })
                end,
                { desc = "Toggle lsp_lines" }
            )
            require("lsp_lines").setup()
        end,
    },
    {
        'simrat39/rust-tools.nvim',
        dependencies = {
            'mfussenegger/nvim-dap',
            'neovim/nvim-lspconfig'
        },
        before = 'mason.nvim',
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

            'neovim/nvim-lspconfig',
            'nvim-telescope/telescope.nvim',
            'SmiteshP/nvim-navic',
            'nvim-navic',
        },
        config = function()
            require('plugins.lsp')
        end
    },
    {
        'L3MON4D3/LuaSnip',
        config = function()
            require('plugins.snips')
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            -- 'L3MON4D3/LuaSnip'
        },
        config = function()
            require('plugins.nvimcmp')
        end
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
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
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require('plugins.dap-ui')
        end
    },

    -- rust plugins
    'cespare/vim-toml',
    'ron-rs/ron.vim',
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

    -- flutter plugins
    'dart-lang/dart-vim-plugin',
    { 'akinsho/flutter-tools.nvim', dependencies = 'nvim-lua/plenary.nvim' },

    -- java plugins
    'mfussenegger/nvim-jdtls',
}
