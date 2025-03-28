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

-- set default shell
if vim.fn.has("unix") then
    if vim.fn.executable("fish") then
        vim.o.shell = "fish"
    elseif vim.fn.executable("zsh") then
        vim.o.shell = "zsh"
    elseif vim.fn.executable("bash") then
        vim.o.shell = "bash"
    end
elseif vim.fn.has("win32") then
    if vim.fn.executable("pwsh") then
        vim.o.shell = "pwsh"
    elseif vim.fn.executable("cmd") then
        vim.o.shell = "cmd"
    end
end

--Set highlight on search
vim.o.hlsearch = true
vim.o.incsearch = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cursorline = true    -- Highlight line
vim.o.scrolloff = 2
vim.o.inccommand = "split" --Incremental live completion
vim.o.hidden = true        --Do not save when switching buffers
vim.o.mouse = "a"          --Enable mouse mode
vim.o.breakindent = true   --Enable break indent
vim.cmd [[set undofile]]   --Save undo history

vim.o.colorcolumn = '+1'   -- colorcolumn at end of textwidth

vim.o.tabstop = 4          -- number of visual spaces per TAB
vim.o.softtabstop = 4      -- number of spaces in tab when editing
vim.o.shiftwidth = 4       -- number of spaces to use for autoindent
vim.o.expandtab = true     -- tabs are space

vim.o.splitright = true
vim.g.splitbelow = true

vim.wo.signcolumn = "yes"
--Decrease update time
vim.o.updatetime = 500

vim.o.modeline = false

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Relative line

vim.wo.number = true
-- local group = augroup("ConfigRelativeLine", { clear = true })
-- autocmd({ 'TermLeave' }, {
--     pattern = "*",
--     command = [[set nu]],
--     group = group,
-- })
-- autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter', 'TermLeave' }, {
--     pattern = "*",
--     command = [[if &nu && mode() != "i" | set rnu | endif]],
--     group = group,
-- })
-- autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'TermEnter', 'WinLeave' }, {
--     pattern = "*",
--     command = [[if &nu | set nornu | endif | if mode() == "t" | set nonumber | endif]],
--     group = group,
-- })

-- Terminal config

local term_group = augroup("ConfigTerminal", { clear = true })
autocmd("WinEnter", {
    group = term_group,
    pattern = "term://*",
    command = 'startinsert'
})
autocmd("TermOpen", {
    group = term_group,
    command = 'set signcolumn=no | set nonumber | startinsert'
})


-- Diagnostics

vim.diagnostic.config({
    log_level = true,
    underline = true,
    signs = true,
    virtual_text = true,
    virtual_lines = false,
    float = {
        source = "if_many",
        show_header = true,
    }
})


-- Set colorscheme

vim.o.guifont = [[CaskaydiaCove NF:h9]]

vim.o.termguicolors = true
vim.g.material_style = "deep ocean"
vim.g.neovide_transparency = 0.8
require('material').setup({
    contrast = {
        terminal = false,            -- Enable contrast for the built-in terminal
        sidebars = false,            -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
        floating_windows = true,     -- Enable contrast for floating windows
        cursor_line = true,          -- Enable darker background for the cursor line
        non_current_windows = false, -- Enable darker background for non-current windows
        filetypes = {},              -- Specify which filetypes get the contrasted (darker) background
    },
    styles = {                       -- Give comments style such as bold, italic, underline etc.
        comments = { --[[ italic = true ]] },
        strings = { --[[ bold = true ]] },
        keywords = { --[[ underline = true ]] },
        functions = { --[[ bold = true, undercurl = true ]] },
        variables = {},
        operators = {},
        types = {},
    },
    plugins = { -- Uncomment the plugins that you use to highlight them
        -- Available plugins:
        "dap",
        -- "dashboard",
        "gitsigns",
        -- "hop",
        "indent-blankline",
        -- "lspsaga",
        -- "mini",
        -- "neogit",
        "nvim-cmp",
        "nvim-navic",
        -- "nvim-tree",
        -- "sneak",
        "telescope",
        -- "trouble",
        -- "which-key",
    },
    disable = {
        colored_cursor = false, -- Disable the colored cursor
        borders = false,        -- Disable borders between verticaly split windows
        background = false,     -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
        term_colors = false,    -- Prevent the theme from setting terminal colors
        eob_lines = false       -- Hide the end-of-buffer lines
    },
    high_visibility = {
        lighter = false,       -- Enable higher contrast text for lighter style
        darker = false         -- Enable higher contrast text for darker style
    },
    lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )
    async_loading = true,      -- Load parts of the theme asyncronously for faster startup (turned on by default)
    custom_colors = nil,       -- If you want to everride the default colors, set this to a function
    custom_highlights = {
        NormalNC = { bg = 'NONE' }
    }
})
vim.cmd [[colorscheme material]]
