local utils = require 'utils'
local map = utils.map

--Remap space as leader key
map('', '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- disable arrows
map('n', '<Up>', '<Nop>')
map('n', '<Down>', '<Nop>')
map('n', '<Left>', '<Nop>')
map('n', '<Right>', '<Nop>')

-- move beetwen windows
-- also leave terminal mode
map('t', '<A-h>', [[<C-\><C-n><C-w>h]])
map('t', '<A-j>', [[<C-\><C-n><C-w>j]])
map('t', '<A-k>', [[<C-\><C-n><C-w>k]])
map('t', '<A-l>', [[<C-\><C-n><C-w>l]])
map('n', '<A-h>', [[<C-w>h]])
map('n', '<A-j>', [[<C-w>j]])
map('n', '<A-k>', [[<C-w>k]])
map('n', '<A-l>', [[<C-w>l]])

local term_group = vim.api.nvim_create_augroup("ConfigTerminal", { clear = true })
utils.autocmd("WinEnter", {
    group = term_group,
    pattern = "term://*",
    command = 'startinsert'
})
utils.autocmd("TermOpen", {
    group = term_group,
    command = 'set nonumber signcolumn=no | startinsert'
})

-- move beetwen tabs
map('t', '<A-H>', [[<C-\><C-n>gT]])
map('t', '<A-L>', [[<C-\><C-n>gt]])
map('n', 'H', [[gT]])
map('n', 'L', [[gt]])

-- open init.lua
map('n', '<F12>', [[:tabnew +exe\ "tcd\ "\ .\ fnamemodify($MYVIMRC,\ ":p:h") $MYVIMRC<CR>]], {})

-- smart home key
map({ 'n', 'v' }, '<Home>', [[col('.') == match(getline('.'),'\S')+1 ? '0' : '^']], { expr = true })
map('i', '<Home>', [[<C-O><Home>]], { silent = true, remap = true })
-- toggle wrap
vim.o.wrap = false
map('n', '<A-z>', function() vim.o.wrap = not vim.o.wrap end)

-- clear search highlight
map('n', '<leader>l', '<cmd>noh<CR>')

-- Highlight on yank
vim.api.nvim_exec([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]], false)

-- Y yank until the end of line
map('n', 'Y', 'y$')
