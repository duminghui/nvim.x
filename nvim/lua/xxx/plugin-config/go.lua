local M = {}

M.opts = {
    goimport = "goimports",
    -- lsp_cfg = true,
}

function M.setup()
    local status_ok, go = safe_require("go")
    if not status_ok then
        return
    end
    go.setup(M.opts)
end

return M
