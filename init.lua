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

local utils = require 'utils'
local map = utils.map
local augroup = utils.augroup
local aucmd = utils.autocmd

-- package.path = package.path .. [[;D:\repos\luajit\src\?.lua]]
-- local profiler = require 'plenary.profile'
-- profiler.start('profile.txt', { flame = true })

require('plugins')
require('options')
require('mappings')

-- Neo-tree

local neotree = require("neo-tree")
neotree.setup({
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    open_files_in_last_window = true,
    event_handlers = {
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
                ["o"]             = "open",
                ["S"]             = "open_split",
                ["s"]             = "open_vsplit",
                ["C"]             = "close_node",
                ["R"]             = "refresh",
                ["d"]             = "delete",
                ["r"]             = "rename",
                ["c"]             = "copy_to_clipboard",
                ["x"]             = "cut_to_clipboard",
                ["p"]             = "paste_from_clipboard",
                ["A"]             = "git_add_all",
                ["gu"]            = "git_unstage_file",
                ["ga"]            = "git_add_file",
                ["gr"]            = "git_revert_file",
                ["gc"]            = "git_commit",
                ["gp"]            = "git_push",
                ["gg"]            = "git_commit_and_push",
            }
        }
    }
})
map('n', '<C-b>', '<cmd>Neotree reveal toggle<cr>')

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
    lsp_status.on_attach(client, bufnr)
    require 'lsp_signature'.on_attach(client, bufnr)

    local opts = { buffer = bufnr }

    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', '<leader>k', vim.lsp.buf.document_highlight, opts)
    map('n', '<leader>l', function()
        vim.cmd('noh')
        vim.lsp.buf.clear_references()
    end, opts)
    map('n', 'ga', vim.lsp.buf.code_action, opts)
    map('v', 'ga', vim.lsp.buf.range_code_action, opts)
    map('n', '<leader>r', vim.lsp.buf.rename, opts)
    map('n', 'g[', vim.diagnostic.goto_prev, opts)
    map('n', 'g]', vim.diagnostic.goto_next, opts)

    local tsb = require 'telescope.builtin'
    map('n', 'gd', tsb.lsp_definitions, opts)
    map('n', 'gt', tsb.lsp_type_definitions, opts)
    map('n', 'gD', tsb.lsp_implementations, opts)
    map('n', '<c-k>', vim.lsp.buf.signature_help, opts)
    map('n', 'gr', tsb.lsp_references, opts)
    map('n', '<leader>fs', tsb.lsp_document_symbols, opts)
    map('n', '<leader>fw', tsb.lsp_workspace_symbols, opts)

    map('n', '<leader>s', function()
        local loc = require('nvim-gps').get_location()
        vim.api.nvim_echo({ { loc } }, false, {})
    end, opts)

    local lsp_group = augroup "Lsp"
    -- Map :Format to vim.lsp.buf.formatting()
    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
    aucmd("BufWritePre", {
        group = lsp_group,
        buffer = bufnr,
        callback = function() vim.lsp.buf.formatting_sync(nil, 1000) end
    })

end

local capabilities = lsp_status.capabilities
nvim_lsp.util.default_config = vim.tbl_extend("keep", nvim_lsp.util.default_config, { capabilities = capabilities })
nvim_lsp.util.default_config.on_attach = on_attach

-- Enable rust analyzer
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
        cmd = { vim.fn.stdpath('data') .. [[/lsp_servers/rust/rust-analyzer]] },
        -- on_attach = on_attach,
        standalone = false,
        single_file_support = false,
        root_dir = function(fname, bufnr)
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
                    importMergeBehavior = "module",
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
        capabilities = function(config)
            return vim.tbl_extend('keep', config or {}, capabilities)
        end,
        -- on_attach = on_attach,
        cmd = { "D:/flutter/bin/dart.bat", "D:/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot",
            "--lsp" }
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
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup {
    cmd = { vim.fn.stdpath('data') .. [[/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server.exe]] },
    -- on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                globals = { 'vim' },
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

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Setup nvim-cmp

local cmp = require 'cmp'
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
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

-- profiler.stop()
