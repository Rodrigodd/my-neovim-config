-- dap settings
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({})
end

local opts = { silent = true }
vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, opts)
vim.keymap.set('n', '<Leader>B', function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, opts)
vim.keymap.set('n', '<Leader>dl', function()
    dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, opts)
vim.keymap.set('n', '<Leader>dr', dap.run_last, opts)
vim.keymap.set('n', '<Leader>dc', dap.run_to_cursor, opts)
vim.keymap.set('n', '<Leader>db', dap.list_breakpoints, opts)

vim.keymap.set('n', '<F5>', dap.continue, opts)
vim.keymap.set('n', '<F9>', dap.step_over, opts)
vim.keymap.set('n', '<F10>', dap.step_into, opts)
vim.keymap.set('n', '<F11>', dap.step_out, opts)

require("dapui").setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    layout = {
        {
            elements = {
                'scopes',
                'breakpoints',
                'stacks',
                'watches'
            },
            size = 40,
            position = 'left'
        },
        {

            elements = {
                'repl',
                'console',
            },
            size = 10,
            position = 'bottom'
        },
    },
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
})
