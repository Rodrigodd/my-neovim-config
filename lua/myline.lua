-- for k, _ in pairs(package.loaded) do
--     if string.match(k, "^cryoline") then
--         package.loaded[k] = nil
--     end
-- end

-- based on: https://elianiva.my.id/post/neovim-lua-statusline

local fn = vim.fn
local api = vim.api
local M = {}

M.trunc_width = setmetatable({
    -- You can adjust these values to your liking, if you want
    -- I promise this will all makes sense later :)
    mode        = 80,
    git_status  = 90,
    filename    = 140,
    line_col    = 60,
    diagnostics = 80,
}, {
    __index = function()
        return 80 -- handle edge cases, if there's any
    end
})

M.is_truncated = function(_, width)
    local current_width = api.nvim_win_get_width(0)
    return current_width < width
end

M.colors = {
    active         = '%#StatusLine#',
    filename       = '%#Filename#',
    close_section  = '%#CloseSection#',
    open_inactive  = '%#OpenInactive#',
    file_inactive  = '%#FileInactive#',
    close_inactive = '%#CloseInactive#',
    open_mode      = '%#OpenMode#',
    mode           = '%#Mode#',
    mode_alt       = '%#ModeAlt#',
    git            = '%#Git#',
    git_alt        = '%#GitAlt#',
    line_col       = '%#LineCol#',
    line_col_alt   = '%#LineColAlt#',
    middle         = '%#MiddleBar#',
    error          = '%#DiagnosticError#',
    warn           = '%#DiagnosticWarn#',
    info           = '%#DiagnosticInfo#',
    hint           = '%#DiagnosticHint#',
    git_add        = '%#GitSignsAdd#',
    git_change     = '%#GitSignsChange#',
    git_delete     = '%#GitSignsDelete#',
}
local colors = require('material.colors').main
-- colors.bg = '#141822'
colors.bg = '#0f111a'
colors.section_bg = '#1e2234'
colors.inactive_file = '#1e2234'

local set_hl = function(group, options)
    local bg = options.bg == nil and '' or 'guibg=' .. options.bg
    local fg = options.fg == nil and '' or 'guifg=' .. options.fg
    local gui = options.gui == nil and '' or 'gui=' .. options.gui

    vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
end

M.highlights = {
    { 'Mode', { bg = colors.green, fg = colors.bg, gui = "bold" } },
    { 'Filename', { bg = colors.section_bg, fg = colors.fg } },
    { 'CloseSection', { bg = 'NONE', fg = colors.section_bg } },
    { 'MiddleBar', { bg = 'NONE', fg = colors.gray } },

    { 'OpenInactive', { bg = colors.inactive_file, fg = colors.bg } },
    { 'FileInactive', { bg = colors.inactive_file, fg = colors.fg } },
    { 'CloseInactive', { bg = colors.bg, fg = colors.inactive_file } },
}

local set_highlights = function()
    for _, highlight in ipairs(M.highlights) do
        set_hl(highlight[1], highlight[2])
    end
end

local line_group = vim.api.nvim_create_augroup('StatusLine', {});
set_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
    group = line_group,
    callback = set_highlights,
})

M.separators = {
    arrow = { '', '' },
    rounded = { '', '' },
    angle = { '', '' },
    slash = { '' },
    blank = { '', '' },
}

M.modes = setmetatable({
    ['n']    = { 'Normal', 'N', color = colors.green };
    ['no']   = { 'NPending', 'N·P', color = colors.green };
    ['niI']  = { 'Normal', 'N·P', color = colors.gray };
    ['niR']  = { 'Normal', 'N·P', color = colors.gray };
    ['niV']  = { 'Normal', 'N·P', color = colors.gray };
    ['v']    = { 'Visual', 'V', color = colors.purple };
    ['V']    = { 'V·Line', 'V·L', color = colors.purple };
    ['\022'] = { 'V·Block', 'V·B', color = colors.purple };
    ['s']    = { 'Select', 'S', color = colors.yellow };
    ['S']    = { 'S·Line', 'S·L', color = colors.yellow };
    ['\019'] = { 'S·Block', 'S·B', color = colors.yellow };
    ['i']    = { 'Insert', 'I', color = colors.blue };
    ['ic']   = { 'Insert', 'I', color = colors.blue };
    ['R']    = { 'Replace', 'R', color = colors.red };
    ['Rv']   = { 'VReplace', 'V·R', color = colors.red };
    ['c']    = { 'Command', 'C', color = colors.purple };
    ['cv']   = { 'Vim·Ex ', 'V·E', color = colors.purple };
    ['ce']   = { 'Ex', 'E', color = colors.purple };
    ['r']    = { 'Prompt', 'P', color = colors.purple };
    ['rm']   = { 'More', 'M', color = colors.purple };
    ['r?']   = { 'Confirm', 'C', color = colors.purple };
    ['!']    = { 'Shell', 'S', color = colors.purple };
    ['t']    = { 'Terminal', 'T', color = colors.purple };
    ['nt']   = { 'Terminal', 'T', color = colors.green };
}, {
    __index = function()
        return { 'Unknown', 'U', color = colors.gray } -- handle edge cases
    end
})

M.get_current_mode = function(self)
    local current_mode = api.nvim_get_mode().mode
    local mode = self.modes[current_mode]

    self.highlights[1][2].bg = mode.color
    set_hl(self.highlights[1][1], self.highlights[1][2])

    if self:is_truncated(self.trunc_width.mode) then
        return string.format(' %s ', mode[2]):upper()
    end

    return string.format(' %7s ', mode[1]):upper()
end

M.get_git_status = function(self)
    -- use fallback because it doesn't set this variable on the initial `BufEnter`
    local signs = vim.tbl_extend(
        'keep',
        vim.b.gitsigns_status_dict or {},
        { head = '', added = 0, changed = 0, removed = 0 }
    )
    local is_head_empty = signs.head ~= ''

    if self:is_truncated(self.trunc_width.git_status) then
        return is_head_empty and string.format('  %s ', signs.head or '') or ''
    end

    return is_head_empty
        and table.concat {
            self.colors.git_add, ' +', signs.added,
            self.colors.git_change, ' ~', signs.changed,
            self.colors.git_delete, ' -', signs.removed,
            self.colors.middle, '   ', signs.head, ' '
        } or ''
end

M.get_filename = function(self)
    local file_name = fn.expand("%:t")
    local file_ext = self.context.ft
    local icon = " " .. require 'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
    local file = icon

    if self:is_truncated(self.trunc_width.filename) then
        file = file .. " %t%<"
    else
        file = file .. " %f%<"
    end

    local info = fn.getbufinfo(self.context.bufnr)
    if info[1].changed == 1 then
        file = file .. ' '
    elseif self.active then
        for _, info in ipairs(fn.getbufinfo()) do
            if info.changed == 1 then
                file = file .. ' •'
                break
            end
        end
    end

    return file .. ' '
end

M.get_line_col = function(self)
    if self:is_truncated(self.trunc_width.line_col) then return ' %l:%c ' end
    return ' %3l :%2c ' .. self.separators.slash[1] .. ' %P '
end

M.get_diagnostic = function(self)
    if self:is_truncated(self.trunc_width.diagnostic) then
        return ''
    end

    local levels = {
        self.colors.error .. ' ',
        self.colors.warn .. ' ',
        self.colors.info .. ' ',
        -- self.colors.hint .. ' '
    }

    -- TODO: move this to DiagnosticsChanged event
    local counts = { 0, 0, 0, 0 }
    for _, v in pairs(vim.diagnostic.get(0)) do
        local s = v.severity
        counts[s] = counts[s] + 1
    end

    local line = ' '
    for i, icon in ipairs(levels) do
        local n = counts[i]
        if n ~= nil and n ~= 0 then
            line = line .. icon .. n .. ' '
        end
    end

    return line
end

M.get_lsp_status = function()
    -- if #vim.lsp.buf_get_clients() > 0 then
    if #vim.lsp.get_active_clients() > 0 then
        return require 'lsp_status_line'.status_line()
    end
    return ''
end

M.set_active = function(self)
    self.active = true
    local colors = self.colors

    local mode = colors.mode .. self:get_current_mode()

    local filename = colors.filename .. self:get_filename()
    local close_section = colors.close_section .. self.separators.angle[1]

    local diagnostics = colors.middle .. self:get_diagnostic()
    local status = colors.middle .. self:get_lsp_status()

    local git = self:get_git_status()
    local open_mode = colors.mode .. self.separators.angle[2]
    local line_col = self:get_line_col()

    return table.concat({
        colors.active, mode, filename, close_section,
        diagnostics, status,
        "%=", git,
        open_mode, line_col
    })
end

M.set_inactive = function(self)
    self.active = false
    return table.concat {
        -- self.colors.close_inactive,
        -- "        ",
        self.colors.open_inactive,
        self.separators.angle[2],
        self.colors.file_inactive,
        self:get_filename(),
        self.colors.close_inactive,
        self.separators.angle[1],
    }
end

M.set_explorer = function(self)
    local title = self.colors.mode .. '   '
    local title_alt = self.colors.mode_alt .. self.separators[active_sep][2]

    return table.concat({ self.colors.active, title, title_alt })
end


require("cryoline").config {
    -- force_ft = { "qf", "help" },
    -- ft = {
    --   lua = function(context)
    --     return (context.active and "%#Error#" or "") .. "%f%=lua is nice!"
    --   end
    -- },
    line = function(context)
        M.context = context
        if context.active then
            return M:set_active()
        else
            return M:set_inactive()
        end
    end
}

Statusline = setmetatable(M, {
    __call = function(self, mode)
        return self["set_" .. mode](self)
    end,
})

return M
