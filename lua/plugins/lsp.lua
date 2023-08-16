local map = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

require("mason").setup {}
require("mason-lspconfig").setup {
    ensure_installed = {},
}

local nvim_lsp = require('lspconfig')
local lsp_status = require('lsp-status')
lsp_status.register_progress()


local on_attach = function(client, bufnr)
    -- print("on attach " .. bufnr)
    lsp_status.on_attach(client, bufnr)
    require 'lsp_signature'.on_attach(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        require 'nvim-navic'.attach(client, bufnr)
    end

    local opts = { buffer = bufnr }

    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', '<leader>k', vim.lsp.buf.document_highlight, opts)
    map('n', '<leader>l', function()
        vim.cmd('noh')
        vim.lsp.buf.clear_references()
    end, opts)
    map({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, opts)
    map('n', '<leader>r', vim.lsp.buf.rename, opts)

    local tsb = require 'telescope.builtin'
    map('n', 'gd', tsb.lsp_definitions, opts)
    map('n', 'gt', tsb.lsp_type_definitions, opts)
    map('n', 'gD', tsb.lsp_implementations, opts)
    map('n', '<c-k>', vim.lsp.buf.signature_help, opts)
    map('n', 'gr', tsb.lsp_references, opts)
    map('n', '<leader>fs', tsb.lsp_document_symbols, opts)
    map('n', '<leader>fw', tsb.lsp_dynamic_workspace_symbols, opts)


    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")
    if client.server_capabilities.documentFormattingProvider then
        local lsp_group = augroup("Lsp", { clear = false })
        -- Map :Format to vim.lsp.buf.format()
        vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({async=true})' ]])
        autocmd("BufWritePre", {
            group = lsp_group,
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({
                    timeout_ms = 1000,
                    filter = function(c) return c.name ~= "tsserver" end,
                })
            end
        })
    end

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
end

local capabilities = lsp_status.capabilities
nvim_lsp.util.default_config = vim.tbl_extend("force", nvim_lsp.util.default_config, { capabilities = capabilities })
nvim_lsp.util.default_config.on_attach = on_attach

--
require 'plugins.lsp.rust'
require 'plugins.lsp.ltex'

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
        on_attach = on_attach,
    }
}

-- Enable clangd
nvim_lsp.clangd.setup {
    -- avoid warnging about multiple different client offset_encodings detected for buffer
    capabilities = vim.tbl_extend('keep', { offsetEncoding = 'utf-16' }, capabilities),

    handlers = lsp_status.extensions.clangd.setup(),
    cmd = {
        "clangd",
        -- "--background-index",
        "--fallback-style=None"
    },
    init_options = {
        clangdFileStatus = true
    },
}


-- Enable lua
nvim_lsp.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {},
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

-- Enable XML language server
nvim_lsp.lemminx.setup {
    autostart = false,
    settings = {},
}

-- Enable texlab language server
nvim_lsp.texlab.setup {
    -- autostart = false,
    cmd = { "texlab" },
    filetypes = { "tex", "plaintex", "bib" },
    single_file_support = true,
    on_attach = function(client, bufnr)
        require('lspconfig.util').default_config.on_attach(client, bufnr)
        local opts = { buffer = bufnr }
        map('n', 'gp', ":TexlabForward<CR>", opts)
    end,
    settings = {
        texlab = {
            auxDirectory = "build",
            bibtexFormatter = "texlab",
            build = {
                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                executable = "latexmk",
                forwardSearchAfter = false,
                onSave = true
            },
            chktex = {
                onEdit = false,
                onOpenAndSave = false
            },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
                executable = [[C:\Users\Rodrigo\AppData\Local\SumatraPDF\SumatraPDF.exe]],
                -- executable = [[D:\repos\sumatrapdf\out\dbg64\SumatraPDF.exe]],
                args = { "-reuse-instance", "%p", "-forward-search", "%f", "%l", "-inverse-search",
                    "nvim --server " .. vim.v.servername .. [[ --remote-send "<esc><esc>:e %f<CR>%lG"]] },

                -- executable = [[C:\Windows\System32\cmd.exe]],
                -- args = { "/k", "start", "echo", "%p", "%f", "%l" },
            },
            latexFormatter = "latexindent",
            latexindent = {
                modifyLineBreaks = false
            },
        },
    },
}

nvim_lsp.marksman.setup {}

-- Enable tailwindcss language server
nvim_lsp.tailwindcss.setup {
    root_dir = nvim_lsp.util.root_pattern('tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js',
        'postcss.config.ts', 'package.json', 'node_modules')
}
nvim_lsp.prismals.setup {}
-- Enable tsserver language server
nvim_lsp.tsserver.setup {}

-- Enable pylyzer
nvim_lsp.pyright.setup {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true
            },
            pythonPath = [[C:\Users\Rodrigo\AppData\Local\Programs\Python\Python39\python.exe]],
        }
    }
}


local mod = {}

---@param server_name string
---@param settings_patcher fun(settings: table): table
function mod.patch_lsp_settings(server_name, settings_patcher)
    local function patch_settings(client)
        client.config.settings = settings_patcher(client.config.settings)
        client.notify("workspace/didChangeConfiguration", {
            settings = client.config.settings,
        })
    end

    local clients = vim.lsp.get_active_clients({ name = server_name })
    if #clients > 0 then
        patch_settings(clients[1])
        return
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client.name == server_name then
                patch_settings(client)
                return true
            end
        end,
    })
end

return mod
