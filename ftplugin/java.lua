local nvim_lsp = require('lspconfig')

local jdtls_path = require('mason-registry').get_package('jdtls'):get_install_path()

-- config_win, config_linux or config_mac
local config_folder = '/config_win'
local VERSION_NUMBER = '1.6.400.v20210924-0641';

local root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew' })

local hash = string.sub(vim.fn.system('md5sum', root_dir), 1, 32)

local data_path = ""
if config_folder == '/config_win' then
    data_path = [[C:\Users\Rodrigo\AppData\Local\Temp\jdtl_]] .. hash
else
    data_path = "/tmp/jdtl_" .. hash
end

local lombok_path = jdtls_path .. '/lombok.jar'

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    -- cmd = { 'jdtls.cmd' },

    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        -- lombok
        '-javaagent:' .. lombok_path,

        '-jar', jdtls_path .. '/plugins/org.eclipse.equinox.launcher_' .. VERSION_NUMBER .. '.jar',

        '-configuration', jdtls_path .. config_folder,

        '-data', data_path
    },

    root_dir = root_dir,

    settings = {
        java = {
            -- project = {
            --     sourcePaths = {
            --         'D:/repos/Unexpected-Keyboard/srcs/juloo.keyboard2',
            --     },
            --     referencedLibraries = {
            --         'D:/DK/Android/android-sdk/platforms/android-30/android.jar',
            --     },
            -- },
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = "C:\\Program Files\\RedHat\\java-1.8.0-openjdk-1.8.0.265-3"
                    },
                    {
                        name = "JavaSE-19",
                        path = "C:\\Users\\Rodrigo\\scoop\\apps\\openjdk\\current",
                        sources = "C:\\Users\\Rodrigo\\scoop\\apps\\openjdk\\current\\lib\\src.zip",
                        default = true,
                    },
                }
            }
        }
    },


    -- capabilities = nvim_lsp.util.default_config.capabilities,
    on_attach = nvim_lsp.util.default_config.on_attach,
}

require('jdtls').start_or_attach(config)
