local map = vim.keymap.set

--Remap space as leader key
map('', '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Remove man page mapping (it only freezes the editor for a while, and return a error at end)
map({ 'n', 'v' }, 'K', '<Nop>')

--Remap for dealing with word wrap
map({ 'n', 'v' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ 'n', 'v' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--Center search result when jumping around
-- map('n', 'n', "nzz")
-- map('n', 'N', "Nzz")

-- disable arrows
map('n', '<Up>', '<Nop>')
map('n', '<Down>', '<Nop>')
map('n', '<Left>', '<Nop>')
map('n', '<Right>', '<Nop>')

-- move beetwen windows
-- also leave terminal mode

_G.move_to_window = function(dir)
    if vim.fn.winnr(dir) == vim.fn.winnr() then
        -- if there is no window in that direction, change tab
        if dir == 'l' then
            vim.cmd('tabnext')
        elseif dir == 'h' then
            vim.cmd('tabprevious')
        end
    else
        vim.cmd('wincmd ' .. dir)
    end
end

map('t', '<A-h>', [[<C-\><C-n><cmd>lua move_to_window('h')<CR>]])
map('t', '<A-j>', [[<C-\><C-n><C-w>j]])
map('t', '<A-k>', [[<C-\><C-n><C-w>k]])
map('t', '<A-l>', [[<C-\><C-n><cmd>lua move_to_window('l')<CR>]])
map('n', '<A-h>', [[<cmd>lua move_to_window('h')<CR>]])
map('n', '<A-j>', [[<C-w>j]])
map('n', '<A-k>', [[<C-w>k]])
map('n', '<A-l>', [[<cmd>lua move_to_window('l')<CR>]])

-- move beetwen tabs
map('t', '<A-H>', [[<C-\><C-n>gT]])
map('t', '<A-L>', [[<C-\><C-n>gt]])
map('t', '<C-PageDown>', [[<C-\><C-n><C-PageDown>]])
map('t', '<C-PageUp>', [[<C-\><C-n><C-PageUp>]])
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

-- map Ctrl+C to copy to clipboard in visual
map('v', '<C-c>', '"+y')

-- visual select pasted text
map('n', 'gp', '`[v`]')

-- copy to clipboard using ctrl+C
map('v', '<C-c>', '"+y')

-- Toggle spellcheck
map('n', '<C-F11>', ':set spell!<CR>')
map('i', '<C-F11>', '<C-O>:set spell!<CR>')

-- diagnostics
map('n', 'g[', vim.diagnostic.goto_prev)
map('n', 'g]', vim.diagnostic.goto_next)

-- map ! to :!
map('n', '!', ':!')
