local M = {}

M.opts = {
    Error = "#FFFFFF",
    Warning = "#FFFFFF",
    Information = "#FFFFFF",
    Hint = "#FFFFFF"
    -- Error = "#db4b4b",
    -- Warning = "#e0af68",
    -- Information = "#0db9d7",
    -- Hint = "#10B981"
}

M.setup = function()
    require("lsp-colors").setup(M.opts)
end


return M
