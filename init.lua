-- TODO:
-- - look at how broke is luasnip
-- - add shortcut to expand the file name path
-- - change filename bg color if there are unsaved buffers
-- - keymap to print breadcrumbs
-- - contribute to gitui with a restore button in log [2] tab
-- - contribute to rust-analyzer with a 'inline import rename'

-- set language to English
vim.cmd([[
set langmenu=en_US.UTF-8    " sets the language of the menu (gvim) 
language en                 " sets the language of the messages / ui (vim)
]])

-- keymap utils
local function keymap(mode, lhs, rhs, opts)
    if opts == nil then
        opts = { noremap = true, silent = true }
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

local function buf_keymap(bufnr, mode, lhs, rhs, opts)
    if opts == nil then
        opts = { noremap = true, silent = true }
    end
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
end


-- Install packer
local execute = vim.api.nvim_command

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '.. install_path)
end

vim.api.nvim_exec([[
    augroup Packer
        autocmd!
        autocmd BufWritePost init.lua PackerCompile
    augroup end
]], false)

local use = require('packer').use
require('packer').startup(function()
    use 'wbthomason/packer.nvim'       -- Package manager
    use 'tpope/vim-commentary'         -- "gc" to comment visual regions/lines
    use {
      'nmac427/guess-indent.nvim',
      config = function() require('guess-indent').setup { auto_cmd = false } end,
    }
    use {
        'windwp/nvim-autopairs',
        config = function ()
            local npairs = require('nvim-autopairs');
            npairs.setup{
                disable_filetype = { "TelescopePrompt" },
                disable_in_macro = false,  -- disable when recording or executing a macro
                ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]],"%s+", ""),
                enable_moveright = true,
                enable_afterquote = true,  -- add bracket pairs after quote
                enable_check_bracket_line = true,  --- check bracket in same line
                check_ts = true,
                map_bs = true,  -- map the <BS> key
                map_c_w = false, -- map <c-w> to delete a pair if possible
                fast_wrap = {
                    map = '<M-e>',
                },
            }
            local Rule = require('nvim-autopairs.rule')
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
        requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'}
    }
    use 'marko-cerovac/material.nvim'
    use 'lukas-reineke/indent-blankline.nvim'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function ()
            require'nvim-treesitter.configs'.setup {
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
        config = function ()
            require('nvim-gps').setup {
                separator = ' > ',
            }
        end
    }
    use {
        'jandamm/cryoline.nvim',
        config = function() require'myline' end,
        requires = { 'kyazdani42/nvim-web-devicons' }
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function()
            require'gitsigns'.setup()
        end
    }
    use 'neovim/nvim-lspconfig'        -- Collection of configurations for built-in LSP client
    use {
        'simrat39/symbols-outline.nvim',
        opt = true,
    }
    use {
        'williamboman/nvim-lsp-installer',
        requires = {'neovim/nvim-lspconfig'},
        config = function ()
        end
    }
    use 'nvim-lua/lsp-status.nvim'
    use 'ray-x/lsp_signature.nvim'
    use {
        'L3MON4D3/LuaSnip',
        config = function ()
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
        }
    }
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim"
        },
    }

    -- dap
    use { "mfussenegger/nvim-dap" }
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }

    -- rust plugins
    use 'cespare/vim-toml'
    use 'mhinz/vim-crates'
    use { 'simrat39/rust-tools.nvim', requires = 'mfussenegger/nvim-dap' }

    -- flutter plugins
    use 'dart-lang/dart-vim-plugin'
    use {'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim'}

    -- java plugins
    use 'mfussenegger/nvim-jdtls'
end)

-- suspend on windows frezze nvim forever
vim.cmd([[
if has("win32") && has("nvim")
  nnoremap <C-z> <nop>
  inoremap <C-z> <nop>
  vnoremap <C-z> <nop>
  snoremap <C-z> <nop>
  xnoremap <C-z> <nop>
  cnoremap <C-z> <nop>
  onoremap <C-z> <nop>
endif
]])

--Set highlight on search
vim.o.hlsearch = true
vim.o.incsearch = true

vim.o.cursorline = true -- Highlight line
vim.o.scrolloff = 2
vim.o.inccommand = "split" --Incremental live completion
vim.wo.number = true --Make line numbers default
vim.o.hidden = true --Do not save when switching buffers
vim.o.mouse = "a" --Enable mouse mode
vim.o.breakindent = true --Enable break indent
vim.cmd[[set undofile]] --Save undo history

_G.set_indent = function ()
    vim.o.tabstop = 4      -- number of visual spaces per TAB
    vim.o.softtabstop = 4  -- number of spaces in tab when editing
    vim.o.shiftwidth = 4   -- number of spaces to use for autoindent
    vim.o.expandtab = true -- tabs are space
end

vim.o.tabstop = 4      -- number of visual spaces per TAB
vim.o.softtabstop = 4  -- number of spaces in tab when editing
vim.o.shiftwidth = 4   -- number of spaces to use for autoindent
vim.o.expandtab = true -- tabs are space

vim.api.nvim_exec([[filetype off]], false)

vim.o.splitright = true
vim.g.splitbelow = true

--Decrease update time
vim.o.updatetime = 300
vim.wo.signcolumn="yes"

--Set colorscheme
vim.o.termguicolors = true
vim.g.material_style = "deep ocean"
vim.g.neovide_transparency = 0.8
require('material').setup({
    contrast = {
		sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
		floating_windows = true, -- Enable contrast for floating windows
		line_numbers = false, -- Enable contrast background for line numbers
		sign_column = false, -- Enable contrast background for the sign column
		cursor_line = false, -- Enable darker background for the cursor line
		non_current_windows = false, -- Enable darker background for non-current windows
		popup_menu = false, -- Enable lighter background for the popup menu
	},
    borders = false,
    italics = {
        comments = false,
        strings = false,
        keywords = false,
        functions = false,
        variables = false
    },
    contrast_filetype = {
        "terminal",
        "packer",
        "qf"
    },
    high_visibility = {
        lighter = false,
        darker = false
    },
    disable = {
        background = true,
        term_colors = false,
        eob_lines = false
    },
    custom_highlights = {}
})
vim.cmd[[colorscheme material]]

vim.o.guifont = [[CaskaydiaCove NF:h9]]

--Remap space as leader key
keymap('', '<Space>', '<Nop>', { noremap = true, silent=true})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap=true, expr = true, silent = true})
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", {noremap= true, expr = true, silent = true})

-- disable arrows
keymap('n', '<Up>', '<Nop>')
keymap('n', '<Down>', '<Nop>')
keymap('n', '<Left>', '<Nop>')
keymap('n', '<Right>', '<Nop>')

-- move beetwen windows
keymap('t', '<A-h>', [[<C-\><C-n><C-w>h]])
keymap('t', '<A-j>', [[<C-\><C-n><C-w>j]])
keymap('t', '<A-k>', [[<C-\><C-n><C-w>k]])
keymap('t', '<A-l>', [[<C-\><C-n><C-w>l]])
keymap('n', '<A-h>', [[<C-w>h]])
keymap('n', '<A-j>', [[<C-w>j]])
keymap('n', '<A-k>', [[<C-w>k]])
keymap('n', '<A-l>', [[<C-w>l]])

-- move beetwen tabs
keymap('t', 'H', [[<C-\><C-n>gT]])
keymap('t', 'L', [[<C-\><C-n>gt]])
keymap('n', 'H', [[gT]])
keymap('n', 'L', [[gt]])

-- open init.lua
keymap('n', '<F12>', [[:tabnew +exe\ "tcd\ "\ .\ fnamemodify($MYVIMRC,\ ":p:h") $MYVIMRC<CR>]])

-- smart home key
-- keymap('n', '<Home>', [[col('.') == match(getline('.'),'\S')+1 ? '0' : '^']])
-- keymap('i', '<Home>', [[<C-O><Home>]], { silent = true })
vim.api.nvim_exec([[
noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
imap <silent> <Home> <C-O><Home>
]], false)

-- toggle wrap
vim.o.wrap = false
keymap('n', '<A-z>', [[<cmd>set wrap!<CR>]])

-- clear search highlight
keymap('n', '<leader>l', '<cmd>noh<CR>')

--Remap escape to leave terminal mode
vim.api.nvim_exec([[
    augroup Terminal
        autocmd!
        au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
        au TermOpen * set nonu
    augroup end
]], false)

-- Highlight on yank
vim.api.nvim_exec([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]], false)

-- Y yank until the end of line
keymap('n', 'Y', 'y$', { noremap = true })

-- Telescope
require('telescope').setup { }


-- Neo-tree

local neotree = require("neo-tree")
neotree.setup({
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    open_files_in_last_window = true,
    event_handles = {
        {
            event = "file_opened",
            handler = function(file_path)
                --auto close
                neotree.close_all()
            end
        },
    },
    filesystem = {
        filtered_items = {
            hide_dotfiles = true,
            hide_gitignored = false,
        },
        follow_current_file = false, -- This will find and focus the file in the
        -- active buffer every time the current file is changed while the tree is open.
        use_libuv_file_watcher = false, -- This will use the OS level file watchers
        -- to detect changes instead of relying on nvim autocmd events.
        window = {
            position = "left",
            width = 40,
            mappings = {
                ["<2-LeftMouse>"] = "open",
                ["o"] = "open",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["C"] = "close_node",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["H"] = "toggle_hidden",
                ["I"] = "toggle_gitignore",
                ["R"] = "refresh",
                ["/"] = "none",
                ["f"] = "filter_on_submit",
                ["<c-x>"] = "clear_filter",
                ["a"] = "add",
                ["d"] = "delete",
                ["r"] = "rename",
                ["c"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
            }
        }
    },
    buffers = {
        show_unloaded = true,
        window = {
            position = "left",
            mappings = {
                ["<2-LeftMouse>"] = "open",
                ["o"] = "open",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["R"] = "refresh",
                ["a"] = "add",
                ["d"] = "delete",
                ["r"] = "rename",
                ["c"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
            }
        },
    },
    git_status = {
        window = {
            position = "float",
            mappings = {
                ["<2-LeftMouse>"] = "open",
                ["o"] = "open",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["C"] = "close_node",
                ["R"] = "refresh",
                ["d"] = "delete",
                ["r"] = "rename",
                ["c"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["A"]  = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push",
            }
        }
    }
})
keymap('n', '<C-b>', '<cmd>NeoTreeRevealToggle<cr>')

--Add leader shortcuts
keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
keymap('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>')

-- dap settings
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

require("dapui").setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    sidebar = {
        -- You can change the order of elements in the sidebar
        elements = {
            -- Provide as ID strings or tables with "id" and "size" keys
            {
                id = "scopes",
                size = 0.25, -- Can be float or integer > 1
            },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 00.25 },
        },
        size = 40,
        position = "left", -- Can be "left", "right", "top", "bottom"
    },
    tray = {
        elements = { "repl" },
        size = 10,
        position = "bottom", -- Can be "left", "right", "top", "bottom"
    },
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
})

-- LSP settings

local lsp_status = require('lsp-status')
lsp_status.register_progress()
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    lsp_status.on_attach(client, bufnr)
    require'lsp_signature'.on_attach(client, bufnr)
    buf_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    buf_keymap(bufnr, 'n', '<leader>k', '<cmd>lua vim.lsp.buf.document_highlight()<CR>')
    buf_keymap(bufnr, 'n', '<leader>l', '<cmd>noh <bar> lua vim.lsp.buf.clear_references()<CR>')
    buf_keymap(bufnr, 'n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    buf_keymap(bufnr, 'v', 'ga', [[:lua vim.lsp.buf.range_code_action()<CR>]])
    buf_keymap(bufnr, 'n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>')
    buf_keymap(bufnr, 'n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    buf_keymap(bufnr, 'n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>')

    buf_keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>')
    buf_keymap(bufnr, 'n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>')
    buf_keymap(bufnr, 'n', 'gD', '<cmd>Telescope lsp_implementations<CR>')
    buf_keymap(bufnr, 'n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    buf_keymap(bufnr, 'n', 'gr', '<cmd>Telescope lsp_references<CR>')
    buf_keymap(bufnr, 'n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<CR>')
    buf_keymap(bufnr, 'n', '<leader>fw', '<cmd>Telescope lsp_workspace_symbols<CR>')

    buf_keymap(bufnr, 'n', '<leader>s', [[<cmd>lua print(require('nvim-gps').get_location())<CR>]])

    vim.api.nvim_exec([[
        augroup Lsp
        autocmd!
        autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)
        augroup end
    ]], false)
end

local capabilities = lsp_status.capabilities
nvim_lsp.util.default_config = vim.tbl_extend("keep", nvim_lsp.util.default_config, { capabilities = capabilities })
nvim_lsp.util.default_config .on_attach = on_attach

-- Enable rust analyzer
vim.api.nvim_exec([[autocmd BufRead Cargo.toml call crates#toggle()]], false)

local extension_path = 'C:/Users/Rodrigo/AppData/Local/nvim/codelldb/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'
-- local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
local liblldb_path = extension_path .. 'lldb/bin/liblldb.dll'

-- vim.lsp.set_log_level("debug")
require('rust-tools').setup {
    tools = {
        -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
        reload_workspace_from_cargo_toml = false,
    },
    server = {
        cmd = {vim.fn.stdpath('data')..[[/lsp_servers/rust/rust-analyzer]]},
        -- on_attach = on_attach,
        standalone = false,
        single_file_support = false,
        root_dir = function (fname, bufnr)
            if fname:match('.cargo/registry') then
                return nil
            end
            if fname:match('.cargo/git') then
                return nil
            end
            if fname:match('.rustup/toolchains') then
                return nil
            end
            return require('lspconfig.server_configurations.rust_analyzer').default_config.root_dir(fname, bufnr)
        end,
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importMergeBehavior = "last",
                    importPrefix = "by_self",
                },
                cargo = {
                    loadOutDirsFromCheck = true,
                    -- features = { "opengl" },
                    -- allFeatures = true,
                    --target
                    -- target = "aarch64-linux-android",
                },
                procMacro = { enable = true },
                -- trace = { server = "verbose" },
                -- diagnostics = {
                --     enableExperimental = true,
                -- }
            }
        }
    },
    dap = {
        adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
    }
}


-- toml lsp
nvim_lsp.taplo.setup {
    cmd = { 'taplo', 'lsp', 'stdio', '--log-spans' },
    settings = {},
}

-- Enable flutter
vim.g.dart_style_guide = 2
require('flutter-tools').setup {
    lsp = {
        capabilities = function (config)
            return vim.tbl_extend('keep', config or {}, capabilities)
        end,
        -- on_attach = on_attach,
        cmd = { "D:/flutter/bin/dart.bat", "D:/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot", "--lsp" }
    }
}

-- Enable clangd
nvim_lsp.clangd.setup {
    -- on_attach = on_attach,
    handlers = lsp_status.extensions.clangd.setup(),
    init_options = {
        clangdFileStatus = true
    },
}

-- Enable sumneko\lua-language-server
local sumneko_root_path = "D:/repos/lua-language-server"
local sumneko_binary_path = "/bin/Windows/lua-language-server.exe" -- Change to your OS specific output folder
nvim_lsp.sumneko_lua.setup {
    cmd = {sumneko_root_path .. sumneko_binary_path, "-E", sumneko_root_path.."/main.lua" };
    -- on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                globals = {'vim'},
            },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
        },
    },
}

-- Map :Format to vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

-- Set completeopt to have a better completion experience
vim.o.completeopt="menuone,noselect"

-- Setup nvim-cmp

local cmp = require'cmp'
local luasnip = require 'luasnip'

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    preselect = cmp.PreselectMode.None,
    mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
