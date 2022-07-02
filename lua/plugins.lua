local utils = require 'utils'
local aucmd = utils.autocmd
local augroup = utils.augroup

-- Install packer
local execute = vim.api.nvim_command

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.api.nvim_exec([[
    augroup Packer
        autocmd!
        autocmd BufWritePost plugins.lua PackerCompile
    augroup end
]], false)

local use = require('packer').use
require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Package manager
    use 'nvim-lua/plenary.nvim'
    use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines
    use {
        'nmac427/guess-indent.nvim',
        config = function()
            require('guess-indent').setup { auto_cmd = false }
        end,
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
    -- UI to select things (files, grep results, open buffers...)
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
        config = function()
            require('plugins.telescope')
        end,
    }
    use 'marko-cerovac/material.nvim'
    use 'lukas-reineke/indent-blankline.nvim'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = {
                    "toml",
                    "rust",
                    "c",
                },
                highlight = {
                    enable = true,
                    disable = {},
                },
                indent = {
                    enable = false,
                    disable = {},
                },
            }
        end
    }
    use {
        "SmiteshP/nvim-gps",
        requires = "nvim-treesitter/nvim-treesitter",
        config = function()
            require('nvim-gps').setup {
                separator = ' > ',
            }
        end
    }
    use {
        'jandamm/cryoline.nvim',
        config = function() require 'myline' end,
        requires = { 'kyazdani42/nvim-web-devicons' }
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require 'gitsigns'.setup()
        end
    }
    use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    use {
        'simrat39/symbols-outline.nvim',
        opt = true,
    }
    use {
        'williamboman/nvim-lsp-installer',
        requires = {
            'neovim/nvim-lspconfig',
            'nvim-telescope/telescope.nvim',
        },
        config = function()
            require('plugins.lsp')
        end
    }
    use 'nvim-lua/lsp-status.nvim'
    use 'ray-x/lsp_signature.nvim'
    use {
        'L3MON4D3/LuaSnip',
        config = function()
            require("luasnip.loaders.from_vscode").load({
                paths = './snippets'
            })
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
    use {
        'saecki/crates.nvim',
        event = { "BufRead Cargo.toml" },
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
            aucmd("FileType toml", {
                group = augroup 'creates.nvim',
                callback = require('cmp').setup.buffer { sources = { { name = 'crates' } } }
            })
        end,
    }
    use {
        'simrat39/rust-tools.nvim',
        requires = {
            'mfussenegger/nvim-dap',
            'neovim/nvim-lspconfig'
        },
        config = function()
            require('plugins.rust')
        end
    }

    -- flutter plugins
    use 'dart-lang/dart-vim-plugin'
    use { 'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim' }

    -- java plugins
    use 'mfussenegger/nvim-jdtls'
end)
