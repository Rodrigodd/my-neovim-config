local utils = require 'utils'
local map = utils.map
local augroup = utils.augroup
local autocmd = utils.autocmd

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
    map('n', '<leader>fd', tsb.diagnostics, opts)

    map('n', '<leader>s', function()
        local loc = require('nvim-gps').get_location()
        vim.api.nvim_echo({ { loc } }, false, {})
    end, opts)

    local lsp_group = augroup "Lsp"
    -- Map :Format to vim.lsp.buf.formatting()
    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
    autocmd("BufWritePre", {
        group = lsp_group,
        buffer = bufnr,
        callback = function() vim.lsp.buf.formatting_sync(nil, 1000) end
    })

end

local capabilities = lsp_status.capabilities
nvim_lsp.util.default_config = vim.tbl_extend("keep", nvim_lsp.util.default_config, { capabilities = capabilities })
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
                path = runtime_path,
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                -- library = vim.api.nvim_get_runtime_file("", true),
                library = {
                    [[C:\Users\Rodrigo\scoop\apps\neovim\current\share\nvim\runtime]],
                    [[C:\Users\Rodrigo\scoop\apps\neovim\current\share\nvim\runtime\lua]],
                }
            },
            telemetry = {
                false
            }
        },
    },
}
