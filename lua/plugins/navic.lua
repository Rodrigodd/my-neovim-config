-- require('nvim-gps').setup {
--     separator = ' > ',
-- }
local navic = require('nvim-navic')

navic.setup {
    highlight = true,
}

local function line_to_echo(line)
    local hl_pattern = [[%%#%w+#]]
    local last = 1
    local last_hl = nil

    local i = 0
    local list = {}

    -- infinite loop protection
    while i < 100 do
        local a, b = string.find(line, hl_pattern, last)
        print(vim.inspect({ a, b }))

        if a == nil then
            a = #line + 1
        end

        list[i] = { string.sub(line, last + 1, a - 3), last_hl }
        i = i + 1

        if b == nil then
            break
        end

        last = b
        last_hl = string.sub(line, a + 2, b - 1)
    end

    list[0] = nil

    print(line)
    print(vim.inspect(list))

    return list
end

vim.keymap.set('n', '<leader>K', function()
    local path = vim.api.nvim_buf_get_name(0) .. ': '
    local loc = nil
    if navic.is_available() then
        loc = line_to_echo(navic.get_location())
    else
        -- loc = { { require('nvim-gps').get_location() or "" } }
    end


    local echo = { { path, 'Comment' } }
    vim.list_extend(echo, loc)
    vim.api.nvim_echo(echo, false, {})
    vim.cmd('redraws')
end, {})
