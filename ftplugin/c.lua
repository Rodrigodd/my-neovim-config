-- Overwrite J to remove trailing newline escape
vim.keymap.set(
    'n', 'J',
    function()
        -- check if current line contains a trailing backslash
        if vim.fn.match(vim.fn.getline('.'), [[\\$]]) == -1 then
            vim.cmd('normal! J')
            return
        end
        -- remeber old search
        local search = vim.fn.getreg('/')
        -- join lines
        vim.cmd([[s/\(\s*\\\)\?\n\s*/ /]])
        -- restore search
        vim.fn.setreg('/', search)
    end,
    { buffer = true, }
)
