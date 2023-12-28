local M = {}

-- Define a function to check the Git status
function M.git_status(pwd, on_status, upstream)
    vim.fn.jobstart('git remote update', {
        detach = true,
        on_exit = function(_, code)
            upstream = upstream or '@{u}'
            local cmd = "cd " .. pwd .. " && git "
            local local_commit = vim.fn.system(cmd .. 'rev-parse @')
            local remote_commit = vim.fn.system(cmd .. 'rev-parse ' .. upstream)
            local base_commit = vim.fn.system(cmd .. 'merge-base @ ' .. upstream)
            local dirty_status = vim.fn.system(cmd .. 'status --porcelain')

            -- Remove trailing newline characters
            local_commit = string.gsub(local_commit, '\n', '')
            remote_commit = string.gsub(remote_commit, '\n', '')
            base_commit = string.gsub(base_commit, '\n', '')

            local status = "up-to-date"

            if local_commit == remote_commit then
                if dirty_status == "" then
                    status = "up-to-date"
                else
                    status = "dirty"
                end
            elseif local_commit == base_commit then
                status = "need to pull"
            elseif remote_commit == base_commit then
                status = "need to push"
            else
                status = "diverged"
            end

            print('on status: ' .. status)
            on_status(status)
        end
    })
end

return M
