local M = {}

-- Define a function to check the Git status
function M.git_status(pwd, upstream)
    upstream = upstream or '@{u}'
    local cmd = "cd " .. pwd .. " && git "
    local local_commit = vim.fn.system(cmd .. 'rev-parse @')
    local remote_commit = vim.fn.system(cmd .. 'rev-parse ' .. upstream)
    local base_commit = vim.fn.system(cmd .. 'merge-base @ ' .. upstream)

    -- Remove trailing newline characters
    local_commit = string.gsub(local_commit, '\n', '')
    remote_commit = string.gsub(remote_commit, '\n', '')
    base_commit = string.gsub(base_commit, '\n', '')

    if local_commit == remote_commit then
        return "up-to-date"
    elseif local_commit == base_commit then
        return "need to pull"
    elseif remote_commit == base_commit then
        return "need to push"
    else
        return "diverged"
    end
end

return M
