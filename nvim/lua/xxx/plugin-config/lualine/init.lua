local Log = require("xxx.core.log")
local M = {
    theme = "auto",
}

M.opts = require("xxx.plugin-config.lualine.styles").get_style(Xvim.lualine.style)

M.setup = function()
    -- avoid running in headless mode since it's harder to detect failures
    if #vim.api.nvim_list_uis() == 0 then
        Log:debug "headless mode detected, skipping running setup for lualine"
        return
    end

    local status_ok, lualine = pcall(require, "lualine")
    if not status_ok then
        return
    end


    local theme_supported, _ = pcall(function()
        require("lualine.utils.loader").load_theme(Xvim.lualine.colorscheme)
    end)
    if not theme_supported then
        vim.schedule(function()
            vim.notify("lualine load theme '" .. Xvim.colorscheme .. "' failed", vim.log.levels.WARN)
        end)
    else
        M.opts.theme = Xvim.lualine.colorscheme
    end

    lualine.setup(M.opts)

end

return M
