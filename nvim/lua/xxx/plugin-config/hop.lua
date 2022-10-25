local M = {}
M.opts  = {
    -- true: when treesitter-context show had bug
    multi_windows = false,
}

M.setup = function()
    local status_ok, hop = safe_require("hop")
    if not status_ok then
        return
    end
    hop.setup(M.opts)
end

return M
