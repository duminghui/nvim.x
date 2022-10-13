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
        search = true,
    }
}

M.setup = function()
    local ok, scrollbar = safe_require("scrollbar")
    if not ok then
        return
    end

    scrollbar.setup(M.opts)

    require("scrollbar.handlers.search").setup()

end

return M
