local M = {}
local Log = require("xxx.core.log")

function M:init()
    Log:debug("config:init")
    require("xxx.config.options").load_defaults()
    require("xxx.core.keymappings").load_defaults()
    require("xxx.core.autocmds").load_defaults()
end

function M:load()
    Log:set_level(Xvim.log.level)
    Log:debug("config:load")
end

return M
