local utils = require 'utils'
local aucmd = utils.autocmd
local augroup = utils.augroup

-- Install packer
local execute = vim.api.nvim_command

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "plugins.lua",
    command = [[echo "packer source" | source <afile> | PackerCompile]],
    group = group,
})

local use = require('packer').use
require('packer').startup({ function()
    use 'lewis6991/impatient.nvim'
    use 'wbthomason/packer.nvim' -- Package manager
    use 'nvim-lua/plenary.nvim'
    use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines
    use 'andrewradev/splitjoin.vim' -- gS to split, gJ to join
    use {
        'nmac427/guess-indent.nvim',
        config = function()
            require('guess-indent').setup { auto_cmd = false }
        end,
    }
    use {
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    }
    use {
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
    }
    use {
        'ggandor/leap.nvim',
        config = function()
            require 'leap'.add_default_mappings()
            -- require 'leap'.init_highlight(true)
        end
    }
    -- UI to select things (files, grep results, open buffers...)
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim'
        },
        config = function()
            require('plugins.telescope')
        end,
    }
    use 'marko-cerovac/material.nvim'
    use 'lukas-reineke/indent-blankline.nvim'
    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'nvim-treesitter/playground',
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        run = ':TSUpdate',
        config = function()
            require 'plugins.treesitter'
        end
    }
    use {
        "SmiteshP/nvim-gps",
        requires = { "nvim-treesitter/nvim-treesitter" },
        after = 'nvim-navic',
        config = function()
            require 'plugins.navic'
        end
    }
    use {
        'jandamm/cryoline.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function() require 'myline' end,
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require 'gitsigns'.setup()
        end
    }
    use {
        'simrat39/symbols-outline.nvim',
        opt = true,
    }
    use {
        'MunifTanjim/exrc.nvim',
        config = function()
            vim.o.exrc = false
            require("exrc").setup({
                files = {
                    ".nvimrc.lua",
                },
            })
        end
    }
    use({
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        as = "lsp_lines",
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
    })
    use {
        'williamboman/mason.nvim',
        requires = {
            'williamboman/mason-lspconfig.nvim',
            'nvim-lua/lsp-status.nvim',
            'neovim/nvim-lspconfig',
            'ray-x/lsp_signature.nvim',

            'neovim/nvim-lspconfig',
            'nvim-telescope/telescope.nvim',
            'SmiteshP/nvim-navic',
        },
        after = 'nvim-navic',
        config = function()
            require('plugins.lsp')
        end
    }
    use {
        'L3MON4D3/LuaSnip',
        config = function()
            require('plugins.snips')
        end
    }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            -- 'L3MON4D3/LuaSnip'
        },
        config = function()
            require('plugins.nvimcmp')
        end
    }
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim"
        },
        config = function()
            require('plugins.neotree')
        end
    }

    -- dap
    use { "mfussenegger/nvim-dap" }
    use {
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
        config = function()
            require('plugins.dap-ui')
        end
    }

    -- rust plugins
    use 'cespare/vim-toml'
    use 'ron-rs/ron.vim'
    use {
        'saecki/crates.nvim',
        tag = 'v0.3.0',
        event = { "BufRead Cargo.toml" },
        requires = { 'nvim-lua/plenary.nvim' },
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
    }
    use {
        'simrat39/rust-tools.nvim',
        requires = {
            'mfussenegger/nvim-dap',
            'neovim/nvim-lspconfig'
        },
        after = 'mason.nvim',
        config = function()
            require('plugins.rust')
        end
    }

    -- flutter plugins
    use 'dart-lang/dart-vim-plugin'
    use { 'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim' }

    -- java plugins
    use 'mfussenegger/nvim-jdtls'
end,
    config = {}
})
