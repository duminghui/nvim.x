local M = {}
M.opts  = {
    multi_windows = true,
}

M.setup = function()
    local status_ok, hop = pcall(require, "hop")
    if not status_ok then
        return
    end
    hop.setup(M.opts)
end

return M
