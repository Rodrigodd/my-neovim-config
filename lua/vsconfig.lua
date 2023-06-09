return function()
    local settings = vim.fn.readfile('.vscode/settings.json')

    for k, v in pairs(settings) do
        settings[k] = vim.split(v, "//")[1]
    end

    local json = vim.fn.json_decode(settings)

    function unflat(json)
        for k, v in pairs(json) do
            if type(k) == 'string' then
                local parts = vim.split(k, ".", { plain = true })
                if vim.tbl_count(parts) > 1 then
                    local root = parts[1]
                    local remain = string.sub(k, string.len(root) + 2)
                    json[k] = nil
                    json[root] = vim.tbl_extend('force', json[root] or {}, { [remain] = v })

                end
            end
        end
        for _, v in pairs(json) do
            if type(v) == 'table' then
                unflat(v)
            end
        end
    end

    unflat(json)
    return json
end
