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
