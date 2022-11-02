local nvim_lsp = require('lspconfig')

nvim_lsp.ltex.setup {
    on_attach = function(client, bufnr)
        require("ltex_extra").setup {
            load_langs = { "pt-Br", "en-US" }, -- table <string> : languages for witch dictionaries will be loaded
            init_check = true, -- boolean : whether to load dictionaries on startup
            path = '.vscode', -- string : path to store dictionaries. Relative path uses current working directory
            log_level = "none", -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
        }

        require('lspconfig.util').default_config.on_attach(client, bufnr)
    end,
    settings = {
        ltex = {}
    },
}
