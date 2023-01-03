-- TODO:
-- - look at how broke is luasnip
-- - contribute to gitui with a restore button in log [2] tab
-- - contribute to rust-analyzer with a 'inline import rename'

-- set language to English
vim.cmd([[
set langmenu=en_US.UTF-8    " sets the language of the menu (gvim) 
language en_US.UTF-8        " sets the language of the messages / ui (vim)
]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print('cloning lazy...')
    print(vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=main", -- latest stable release
        lazypath,
    }))
end
vim.opt.rtp:prepend(lazypath)

local plugins = require('plugins')
require("lazy").setup(plugins)

require('options')
require('mappings')
