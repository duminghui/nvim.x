local M = {}

M.setup = function()
    local status_ok, _ = safe_require("luasnip")
    if not status_ok then
        return
    end

    local utils = require "xxx.utils"
    local paths = {}
    paths[#paths + 1] = join_paths(get_runtime_dir(), "site", "pack", "packer", "start", "friendly-snippets")
    local user_snippets = join_paths(get_config_dir(), "snippets")
    if utils.is_directory(user_snippets) then
        paths[#paths + 1] = user_snippets
    end
    require("luasnip.loaders.from_lua").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load {
        paths = paths,
    }
    require("luasnip.loaders.from_snipmate").lazy_load()

end

return M