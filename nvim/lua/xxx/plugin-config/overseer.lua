local M = {}

M.opts = {
    task_list = {
        -- Default detail level for tasks. Can be 1-3.
        default_detail = 2,
        -- Default direction. Can be "left" or "right"
        direction = "right"
    }
}

function M.setup()
    local status_ok, overseer = safe_require("overseer")
    if not status_ok then
        return
    end
    -- overseer.setup(M.opts)
    overseer.setup()
end

return M
