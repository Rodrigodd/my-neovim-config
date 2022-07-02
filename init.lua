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

-- package.path = package.path .. [[;D:\repos\luajit\src\?.lua]]
-- local profiler = require 'plenary.profile'
-- profiler.start('profile.txt', { flame = true })

require('plugins')
require('options')
require('mappings')

-- profiler.stop()
