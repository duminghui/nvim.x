local Log = require "xxx.core.log"

local M = {}

M.setup = function()
    local status_ok, context = safe_require("treesitter-context")
    if not status_ok then
        Log:error "Failed to load treesitter-context"
        return
    end

    context.setup({
        mode = "topline",
    })

    vim.cmd("highlight link TreesitterContextLineNumber TreesitterContext")

end

return M
