local M = {}

local messages = require('lsp-status/messaging').messages

function M.status_line(bufnr)
    bufnr = bufnr or 0
    if #vim.lsp.buf_get_clients(bufnr) == 0 then return 'no clients' end
    local buf_messages = messages()
    local msgs = {}
    for _, msg in ipairs(buf_messages) do
        local name = msg.name
        local client_name = '[' .. name .. ']'
        local contents
        if msg.progress then
            contents = msg.title
            if msg.message then contents = contents .. ' ' .. msg.message end

            if msg.percentage then contents = contents .. ' (' .. msg.percentage .. ')' end

            if msg.spinner then
                contents = ' ' .. contents
            end
        elseif msg.status then
            contents = msg.content
            if msg.uri then
                local filename = vim.uri_to_fname(msg.uri)
                filename = vim.fn.fnamemodify(filename, ':~:.')
                local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
                if #filename > space then filename = vim.fn.pathshorten(filename) end

                contents = '(' .. filename .. ') ' .. contents
            end
        else
            contents = msg.content
        end

        table.insert(msgs, client_name .. ' ' .. contents)
    end
    local base_status = vim.trim(table.concat(msgs, ' '))
    return base_status .. ' '
end

return M
