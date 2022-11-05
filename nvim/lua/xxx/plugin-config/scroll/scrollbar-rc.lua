local M = {}

M.opts = {
    max_lines = 500,
    marks = {
        Search = {
            color = "#FFD700"
        },
    },
    handlers = {
        diagnostic = true,
        -- runtime must run before hlslens.setup()
        search = true,
    }
}

function M.setup()
    local ok, scrollbar = safe_require("scrollbar")
    if not ok then
        return
    end

    scrollbar.setup(M.opts)

end

return M
