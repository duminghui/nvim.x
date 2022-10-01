local M = {}
M.load = function()
    require("xxx.core.keymappings").load_defaults()
    local autocmds = require "xxx.core.autocmds"
    autocmds.load_defaults()
    require "xxx.config.settings".setup()
end
return M
