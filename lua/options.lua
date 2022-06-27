-- suspend on windows frezze nvim forever
vim.cmd([[
if has("win32") && has("nvim")
  nnoremap <C-z> <nop>
  inoremap <C-z> <nop>
  vnoremap <C-z> <nop>
  snoremap <C-z> <nop>
  xnoremap <C-z> <nop>
  cnoremap <C-z> <nop>
  onoremap <C-z> <nop>
endif
]])

--Set highlight on search
vim.o.hlsearch = true
vim.o.incsearch = true

vim.o.cursorline = true -- Highlight line
vim.o.scrolloff = 2
vim.o.inccommand = "split" --Incremental live completion
vim.wo.number = true
vim.o.hidden = true --Do not save when switching buffers
vim.o.mouse = "a" --Enable mouse mode
vim.o.breakindent = true --Enable break indent
vim.cmd [[set undofile]] --Save undo history

vim.o.tabstop = 4 -- number of visual spaces per TAB
vim.o.softtabstop = 4 -- number of spaces in tab when editing
vim.o.shiftwidth = 4 -- number of spaces to use for autoindent
vim.o.expandtab = true -- tabs are space

vim.o.splitright = true
vim.g.splitbelow = true

vim.wo.signcolumn = "yes"
--Decrease update time
vim.o.updatetime = 500


-- Set colorscheme

vim.o.guifont = [[CaskaydiaCove NF:h9]]

vim.o.termguicolors = true
vim.g.material_style = "deep ocean"
vim.g.neovide_transparency = 0.8
require('material').setup({
    contrast = {
        sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
        floating_windows = true, -- Enable contrast for floating windows
        line_numbers = false, -- Enable contrast background for line numbers
        sign_column = false, -- Enable contrast background for the sign column
        cursor_line = false, -- Enable darker background for the cursor line
        non_current_windows = false, -- Enable darker background for non-current windows
        popup_menu = false, -- Enable lighter background for the popup menu
    },
    borders = false,
    italics = {
        comments = false,
        strings = false,
        keywords = false,
        functions = false,
        variables = false
    },
    contrast_filetype = {
        "terminal",
        "packer",
        "qf"
    },
    high_visibility = {
        lighter = false,
        darker = false
    },
    disable = {
        background = true,
        term_colors = false,
        eob_lines = false
    },
    custom_highlights = {}
})
vim.cmd [[colorscheme material]]
