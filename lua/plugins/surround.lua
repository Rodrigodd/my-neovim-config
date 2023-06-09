require("nvim-surround").setup({
    aliases = {
        ["b"] = false,
    },
    surrounds = {
        -- comment
        ["c"] = {
            add = function()
                return { { "/*" }, { "*/" } }
            end,
        },
        -- generic
        ["g"] = {
            add = function()
                local config = require("nvim-surround.config")
                local result = config.get_input("Enter the struct name: ")
                if result then
                    return { { result .. "<" }, { ">" } }
                end
            end,
        },
        -- block
        ["b"] = {
            add = function()
                local config = require("nvim-surround.config")
                local result = config.get_input("Enter the block name: ")
                if result then
                    return { { result .. "{" }, { "}" } }
                end
            end,
        },
    }
})
