local M = {}
local Log = require("xxx.core.log")

function M:init()
    Log:debug("config:init")
    require("xxx.core.keymappings").load_defaults()
    require("xxx.config.settings").load_defaults()
    require("xxx.core.autocmds").load_defaults()
end

function M:load()
    Log:debug("config:load")
end

return M
