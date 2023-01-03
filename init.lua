-- TODO:
-- - look at how broke is luasnip
-- - contribute to gitui with a restore button in log [2] tab
-- - contribute to rust-analyzer with a 'inline import rename'

-- set language to English
vim.cmd([[
set langmenu=en_US.UTF-8    " sets the language of the menu (gvim) 
language en_US.UTF-8        " sets the language of the messages / ui (vim)
]])

local status_ok, mod = pcall(require, 'impatient')
if not status_ok then
    vim.notify("impatient.nvim is not installed")
end

require('plugins')
require('options')
require('mappings')
