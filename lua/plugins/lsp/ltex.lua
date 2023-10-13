local nvim_lsp = require('lspconfig')

nvim_lsp.ltex.setup {
    autostart = false,
    on_attach = function(client, bufnr)
        require("ltex_extra").setup {
            load_langs = { "pt-Br", "en-US" }, -- table <string> : languages for witch dictionaries will be loaded
            init_check = true,                 -- boolean : whether to load dictionaries on startup
            path = '.vscode/',                 -- string : path to store dictionaries. Relative path uses current working directory
            log_level = "none",                -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
        }

        require('lspconfig.util').default_config.on_attach(client, bufnr)
    end,
    settings = {
        ltex = {}
    },
    on_init = function(client)
        local status, config = pcall(require('vsconfig'))
        if not status then
            return false
        end

        client.config.settings["ltex"] = vim.tbl_extend('force', client.config.settings["ltex"],
            config["ltex"])

        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        return true
    end
}
