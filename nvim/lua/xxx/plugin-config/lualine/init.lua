local M = {}

M.setup = function()
    -- avoid running in headless mode since it's harder to detect failures
    if #vim.api.nvim_list_uis() == 0 then
        print "headless mode detected, skipping running setup for lualine"
        return
    end


    -- local style_key = "default"
    local style_key = "xxx"
    local style = require("xxx.plugin-config.lualine.styles").get_style(style_key)

    require "lualine".setup(style)

end

return M
