local M = {}

-- local style_key = "default"
local style_key = "xxx"
M.opts = require("xxx.plugin-config.lualine.styles").get_style(style_key)

M.setup = function()
    -- avoid running in headless mode since it's harder to detect failures
    if #vim.api.nvim_list_uis() == 0 then
        local Log = require "xxx.core.log"
        Log:debug "headless mode detected, skipping running setup for lualine"
        return
    end

    local status_ok, lualine = pcall(require, "lualine")
    if not status_ok then
        return
    end


    lualine.setup(M.opts)

end

return M
