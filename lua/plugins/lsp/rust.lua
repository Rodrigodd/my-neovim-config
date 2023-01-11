-- Enable rust analyzer
local extension_path = vim.fn.stdpath('data') .. [[/mason/packages/codelldb/extension]]
local codelldb_path = extension_path .. '/adapter/codelldb'
-- local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
local liblldb_path = extension_path .. '/lldb/bin/liblldb.dll'

-- vim.lsp.set_log_level("debug")
require('rust-tools').setup {
    tools = {
        -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
        reload_workspace_from_cargo_toml = false,
    },
    server = {
        cmd = { "rust-analyzer" },
        on_attach = require('lspconfig.util').default_config.on_attach,
        standalone = false,
        root_dir = function(fname)
            if fname:match('.cargo/registry') then
                return nil
            end
            if fname:match('.cargo/git') then
                return nil
            end
            if fname:match('.rustup/toolchains') then
                return nil
            end
            return require('lspconfig.server_configurations.rust_analyzer').default_config.root_dir(fname)
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
                    -- target = "wasm32-unknown-unknown",
                },
                checkOnSave = {
                    command = "clippy",
                },
                procMacro = { enable = true },
                inlayHints = { locationLinks = false },
                -- trace = { server = "verbose" },
                -- diagnostics = {
                --     enableExperimental = true,
                -- }
            }
        },
        on_init = function(client)
            local config, err = pcall(require, 'vsconfig')
            if err then
                return false
            end

            client.config.settings["rust-analyzer"] = vim.tbl_extend('force', client.config.settings["rust-analyzer"],
                config["rust-analyzer"])
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            return true
        end
    },
    dap = {
        -- adapter = {
        --     type = "server",
        --     port = "5432",
        --     executable = {
        --         command = codelldb_path,
        --         args = { "--liblldb", liblldb_path, "--port", "${port}" },
        --         detached = false,
        --     },
        -- },
        -- adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
        adapter = {
            type = "server",
            port = "57693",
            host = "127.0.0.1",
            executable = {
                command = codelldb_path,
                args = { "--port", "${port}", "--liblldb", liblldb_path },
            }
        }
    }
}
