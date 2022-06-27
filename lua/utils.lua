local M = {}

-- Map a key
M.map = vim.keymap.set
M.augroup = function(name, opts) vim.api.nvim_create_augroup(name, opts or {}) end
M.autocmd = vim.api.nvim_create_autocmd

return M
