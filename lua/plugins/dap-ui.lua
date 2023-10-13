-- dap settings
local dap, dapui = require("dap"), require("dapui")

local debug_win = nil
local debug_tab = nil
local debug_tabnr = nil

local function open_in_tab()
    if debug_win and vim.api.nvim_win_is_valid(debug_win) then
        vim.api.nvim_set_current_win(debug_win)
        return
    end

    vim.cmd('tabedit %')
    debug_win = vim.fn.win_getid()
    debug_tab = vim.api.nvim_win_get_tabpage(debug_win)
    debug_tabnr = vim.api.nvim_tabpage_get_number(debug_tab)

    dapui.open()
end

local function close_tab()
    dapui.close()

    if debug_tab and vim.api.nvim_tabpage_is_valid(debug_tab) then
        vim.api.nvim_exec('tabclose ' .. debug_tabnr, false)
    end

    debug_win = nil
    debug_tab = nil
    debug_tabnr = nil
end

dap.listeners.after.event_initialized["dapui_config"] = function()
    open_in_tab()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    -- close_tab()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    -- close_tab()
end

local function load_tasks()
    require('dap.ext.vscode').load_launchjs(nil, { lldb = { 'rust', 'c', 'cpp' }, cppdbg = { 'c', 'cpp', 'rust' } })
    vim.print(dap.configurations)
    if dap.configurations.rust == nil then
        dap.configurations.rust = {}
    end
    for _, conf in pairs(dap.configurations.rust) do
        if conf.cargo ~= nil then
            local cmd = { 'cargo' }
            cmd = vim.list_extend(cmd, conf.cargo.args)
            cmd = vim.list_extend(cmd, { '--message-format=json' })
            vim.pretty_print(cmd)
            conf.program = coroutine.create(function(dap_run_co)
                vim.fn.jobstart(
                    cmd,
                    {
                        env = conf.cargo.env,
                        stdout_buffered = true,
                        on_stdout = function(_, data)
                            for _, line in pairs(data) do
                                if line ~= '' then
                                    local message = vim.fn.json_decode(line)
                                    if message.executable ~= nil and message.executable ~= vim.NIL then
                                        vim.pretty_print(message.executable)
                                        coroutine.resume(dap_run_co, message.executable)
                                    end
                                end
                            end
                        end
                    }
                )
            end)
        end
    end
end

require('dap.ext.vscode').json_decode = require 'json5'.parse

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

vim.keymap.set('n', '<F5>', function()
    load_tasks()
    dap.continue()
end, opts)

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
        max_height = nil,  -- These can be integers or a float between 0 and 1.
        max_width = nil,   -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
})

local cpptools_extension_path = vim.fn.stdpath('data') ..
    [[/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7]]
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = cpptools_extension_path,
}

local codelldb_extension_path = vim.fn.stdpath('data') .. [[/mason/packages/codelldb/extension]]
local codelldb_path = codelldb_extension_path .. '/adapter/codelldb'
-- local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
local liblldb_path = codelldb_extension_path .. '/lldb/bin/liblldb.dll'

dap.adapters.lldb = {
    command = "lldb-vscode",
    executable = {
        args = { "--port", "57693", "--liblldb", liblldb_path },
        command = codelldb_path,
        detached = false
    },
    host = "127.0.0.1",
    name = "lldb",
    port = "57693",
    type = "server"
}
