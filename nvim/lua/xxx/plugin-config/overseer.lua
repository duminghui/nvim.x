local M = {}

M.opts = {

}

function M.setup()
    local status_ok, overseer = safe_require("overseer")
    if not status_ok then
        return
    end
    overseer.setup()
end

return M
