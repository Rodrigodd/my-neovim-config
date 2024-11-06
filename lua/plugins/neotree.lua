local neotree = require("neo-tree")
neotree.setup({
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    open_files_in_last_window = true,
    event_handlers = {
        {
            event = "file_opened",
            handler = function()
                --auto close
                neotree.close_all()
            end
        },
    },
    filesystem = {
        -- "auto"   means refreshes are async, but it's synchronous when called from the Neotree commands.
        -- "always" means directory scans are always async.
        -- "never"  means directory scans are never async.
        async_directory_scan = "always",

        filtered_items = {
            hide_dotfiles = true,
            hide_gitignored = false,
        },
        -- active buffer every time the current file is changed while the tree is open.
        use_libuv_file_watcher = false, -- This will use the OS level file watchers
        -- to detect changes instead of relying on nvim autocmd events.
        window = {
            position = "left",
            width = 40,
            mappings = {
                ["<2-LeftMouse>"] = "open",
                ["o"] = "open",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["C"] = "close_node",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["H"] = "toggle_hidden",
                ["I"] = "toggle_gitignore",
                ["R"] = "refresh",
                ["/"] = "none",
                ["f"] = "filter_on_submit",
                ["<c-x>"] = "clear_filter",
                ["a"] = "add",
                ["d"] = "delete",
                ["r"] = "rename",
                ["c"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
            }
        }
    },
    buffers = {
        show_unloaded = true,
        window = {
            position = "left",
            mappings = {
                ["<2-LeftMouse>"] = "open",
                ["o"] = "open",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["R"] = "refresh",
                ["a"] = "add",
                ["d"] = "delete",
                ["r"] = "rename",
                ["c"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
            }
        },
    },
    git_status = {
        window = {
            position = "float",
            mappings = {
                ["<2-LeftMouse>"] = "open",
                ["o"]             = "open",
                ["S"]             = "open_split",
                ["s"]             = "open_vsplit",
                ["C"]             = "close_node",
                ["R"]             = "refresh",
                ["d"]             = "delete",
                ["r"]             = "rename",
                ["c"]             = "copy_to_clipboard",
                ["x"]             = "cut_to_clipboard",
                ["p"]             = "paste_from_clipboard",
                ["A"]             = "git_add_all",
                ["gu"]            = "git_unstage_file",
                ["ga"]            = "git_add_file",
                ["gr"]            = "git_revert_file",
                ["gc"]            = "git_commit",
                ["gp"]            = "git_push",
                ["gg"]            = "git_commit_and_push",
            }
        }
    }
})

vim.keymap.set('n', '<C-b>', '<cmd>Neotree reveal toggle<cr>')
