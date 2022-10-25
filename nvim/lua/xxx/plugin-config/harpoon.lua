local M = {}

M.opts = {
    global_settings = {
        save_on_toggle = true,
        mark_branch = true,
    },
}

function M.setup()
    local status_ok, harpoon = safe_require("harpoon")
    if not status_ok then
        return
    end
    harpoon.setup(M.opts)
end

return M
