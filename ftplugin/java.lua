local lsp_installer_servers = require("nvim-lsp-installer.servers")
local _, jdtls = lsp_installer_servers.get_server("jdtls")
local nvim_lsp = require('lspconfig')

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = jdtls:get_default_options().cmd,

    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            project = {
                sourcePaths = {
                    'D:/repos/Unexpected-Keyboard/srcs/juloo.keyboard2',
                },
                referencedLibraries = {
                    'D:/DK/Android/android-sdk/platforms/android-30/android.jar',
                },
            },
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = "C:/Program Files/RedHat/java-1.8.0-openjdk-1.8.0.265-3",
                    }
                }
            }
        }
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
        bundles = {}
    },
}

config = vim.tbl_extend("keep", nvim_lsp.util.default_config, config)

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
