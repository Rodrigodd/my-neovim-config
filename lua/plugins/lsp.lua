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
    print("on attach " .. bufnr)
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

    if client.server_capabilities.documentFormattingProvider then
        local lsp_group = augroup("Lsp", { clear = false })
        -- Map :Format to vim.lsp.buf.format()
        vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({async=true})' ]])
        autocmd("BufWritePre", {
            group = lsp_group,
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({ timeout_ms = 1000 }) end
        })
        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    end

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
end

local capabilities = lsp_status.capabilities
nvim_lsp.util.default_config = vim.tbl_extend("force", nvim_lsp.util.default_config, { capabilities = capabilities })
nvim_lsp.util.default_config.on_attach = on_attach

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


nvim_lsp.sumneko_lua.setup {
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

require 'plugins.lsp.rust'
require 'plugins.lsp.ltex'


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
