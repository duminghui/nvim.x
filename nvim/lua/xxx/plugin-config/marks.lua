local M = {}
M.opts = {

}

function M.setup()
    local status_ok, marks = safe_require("marks")
    if not status_ok then
        return
    end
    marks.setup(M.opts)
end

return M
