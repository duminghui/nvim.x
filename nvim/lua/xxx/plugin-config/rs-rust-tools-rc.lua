local M = {}

M.opts = {
    server = {
        standalong = false,
    }
}

function M.setup()
    local status_ok, rust_tools = safe_require("rust-tools")
    if not status_ok then
        return
    end
    rust_tools.setup(M.opts)
end

return M
