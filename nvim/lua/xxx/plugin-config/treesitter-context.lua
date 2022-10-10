local Log = require "xxx.core.log"

local M = {}

M.setup = function()
    local status_ok, context = pcall(require, "treesitter-context")
    if not status_ok then
        Log:error "Failed to load treesitter-context"
        return
    end

    context.setup({
        mode = "topline",
    })
end

return M
