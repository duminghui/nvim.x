local M = {}

if vim.fn.has "nvim-0.7" ~= 1 then
    vim.notify(
        "Please upgrade your Neovim base installation. Lunarvim requires v0.7+",
        vim.log.levels.WARN)
    vim.wait(5000, function() return false end)
    vim.cmd "cquit"
end

local uv = vim.loop
local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"
local in_headless = #vim.api.nvim_list_uis() == 0

---Join path segments that were passed as input
---@return string
function _G.join_paths(...)
    local result = table.concat({ ... }, path_sep)
    return result
end

---Require a module in protected mode without relying on its cached value
---@param module string
---@return any
function _G.require_clean(module)
    package.loaded[module] = nil
    _G[module] = nil
    local _, requested = pcall(require, module)
    return requested
end

---Initialize the `&runtimepath` variables and prepare for startup
---@return table
function M:init(base_dir, config_dir)
    -- runtime_dir base_dir/nvim-data

    self.runtime_dir = join_paths(base_dir, "nvim-data")
    _G.get_runtime_dir = function() return self.runtime_dir end

    -- config_dir: base_dir/nvim
    self.config_dir = config_dir
    _G.get_config_dir = function() return self.config_dir end

    -- cache_dir = Local\Temp\nvim.i
    local cache_dir = vim.call("stdpath", "cache")
    cache_dir = join_paths(cache_dir:match("(.*[/\\])"):sub(1, -2), "nvim.i")
    self.cache_dir = cache_dir
    _G.get_cache_dir = function() return self.cache_dir end

    self.pack_dir = join_paths(self.runtime_dir, "site", "pack")
    self.packer_install_dir = join_paths(self.runtime_dir, "site", "pack",
        "packer", "start", "packer.nvim")
    self.packer_compile_dir = join_paths(self.config_dir, "packer")
    self.packer_compile_path = join_paths(self.packer_compile_dir, "plugin", "packer_compiled.lua")
    -- self.packer_compile_path = join_paths(self.config_dir, "plugin",
    --     "packer_compiled.lua")

    -- print("-----------")
    -- print("runtime_dir:        ", self.runtime_dir)
    -- print("config_dir:          ", self.config_dir)
    -- print("pack_dir:            ", self.pack_dir)
    -- print("packer_install_dir:  ", self.packer_install_dir)
    -- print("packer_compile_path: ", self.packer_compiled_path)
    -- print("cache_dir:           ", self.cache_dir)

    ---@meta overridden to use CACHE_DIR instead, since a lot of plugins call this function interally
    ---NOTE: changes to "data" are currently unstable, see #2507
    vim.fn.stdpath = function(what)
        local path = ""
        local what_msg = what
        if what == "config" then
            path = _G.get_config_dir()
        elseif what == "data" then
            path = _G.get_runtime_dir()
            what_msg = what .. "  "
        elseif what == "cache" then
            path = _G.get_cache_dir()
            what_msg = what .. " "
        else
            path = vim.call("stdpath", what)
        end
        -- print("what:" .. what_msg .. ":" .. path)
        return path
    end

    ---Get the full path to base directory
    ---@return string
    function _G.get_base_dir() return base_dir end

    -- print("####: ", vim.call("stdpath", "data"))
    -- print("####: ", vim.fn.stdpath("data"))

    local backupdir = join_paths(vim.fn.stdpath("data"), "backup")
    vim.opt.backupdir = { ".", backupdir }

    vim.opt.directory = join_paths(vim.fn.stdpath("data"), "swap")

    vim.opt.undodir = join_paths(vim.fn.stdpath("data"), "undo")

    local viewdir = join_paths(vim.fn.stdpath("data"), "view")
    vim.opt.viewdir = viewdir

    vim.opt.shadafile = join_paths(vim.fn.stdpath("data"), "shada", "nvimi.shada")

    vim.opt.rtp:prepend(self.packer_compile_dir)
    vim.opt.rtp:remove(join_paths(vim.call("stdpath", "data"), "site"))
    vim.opt.rtp:remove(join_paths(vim.call("stdpath", "data"), "site", "after"))
    vim.opt.rtp:prepend(join_paths(self.runtime_dir, "site"))
    vim.opt.rtp:append(join_paths(self.runtime_dir, "site", "after"))

    vim.opt.rtp:remove(vim.call("stdpath", "config"))
    vim.opt.rtp:remove(join_paths(vim.call("stdpath", "config"), "after"))
    vim.opt.rtp:prepend(self.config_dir)
    vim.opt.rtp:append(join_paths(self.config_dir, "after"))
    --
    -- -- TODO: we need something like this: vim.opt.packpath = vim.opt.rtp

    vim.cmd [[let &packpath = &runtimepath]]
    -- end

    -- require("lvim.config"):init()

    require("xxx.plugin-loader").init {
        package_root = self.pack_dir,
        install_path = self.packer_install_dir,
        compile_path = self.packer_compile_path,
    }

    return self
end

return M
