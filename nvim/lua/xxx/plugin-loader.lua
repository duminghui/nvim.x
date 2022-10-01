local plugin_loader = {}

local utils = require "xxx.utils"
local Log = require "xxx.log"
local join_paths = utils.join_paths
local in_headless = #vim.api.nvim_list_uis() == 0

-- we need to reuse this outside of init()
-- local compile_path = join_paths(get_config_dir(), "plugin",
--     "packer_compiled.lua")
local snapshot_path = join_paths(get_cache_dir(), "snapshots")
local default_snapshot = join_paths(get_base_dir(), "snapshots", "default.json")

function plugin_loader.init(opts)
    opts = opts or {}

    local install_path = opts.install_path or
        join_paths(vim.fn.stdpath "data", "site", "pack",
            "packer", "start", "packer.nvim")
    local compile_path = opts.compile_path or join_path(get_config_dir(), "plugin", "packer_compiled.lua")

    local init_opts = {
        package_root = opts.package_root or
            join_paths(vim.fn.stdpath "data", "site", "pack"),
        compile_path = compile_path,
        snapshot_path = snapshot_path,
        max_jobs = 100,
        log = { level = "warn" },
        git = { clone_timeout = 300 },
        display = {
            open_fn = function()
                return require("packer.util").float { border = "single" }
            end
        }
    }

    -- print("plugin-loader:", init_opts.package_root)
    -- print("plugin-loader:", install_path)
    -- print("plugin-loader:", compile_path)

    if in_headless then init_opts.display = nil end

    if not utils.is_directory(install_path) then
        vim.fn.system {
            "git", "clone", "--depth", "1",
            "https://github.com/wbthomason/packer.nvim", install_path
        }
        vim.cmd "packadd packer.nvim"
        -- IMPORTANT: we only set this the very first time to avoid constantly triggering the rollback function
        -- https://github.com/wbthomason/packer.nvim/blob/c576ab3f1488ee86d60fd340d01ade08dcabd256/lua/packer.lua#L998-L995
        init_opts.snapshot = default_snapshot
    end

    local status_ok, packer = pcall(require, "packer")
    -- print("plugin:", status_ok)
    if status_ok then
        packer.on_complete = vim.schedule_wrap(function()
            -- 这块在什么时候执行?
            -- print("##: packer.on_complete")
            vim.api.nvim_exec_autocmds("User", { pattern = "PackerComplete" })

            -- vim.g.colors_name = lvim.colorscheme
            -- pcall(vim.cmd, "colorscheme " .. lvim.colorscheme)
        end)
        packer.init(init_opts)
    end
end

function plugin_loader.load(configurations)
    Log:debug "loading plugins configuration"
    local packer_available, packer = pcall(require, "packer")
    if not packer_available then
        Log:warn "skipping loading plugins until Packer is installed"
        return
    end
    local status_ok, _ = xpcall(function()
        packer.reset()
        packer.startup(function(use)
            for _, plugins in ipairs(configurations) do
                for _, plugin in ipairs(plugins) do
                    -- print(plugin[1])
                    use(plugin)
                end
            end
        end)
    end, debug.traceback)
    if not status_ok then
        Log:warn "problems detected while loading plugins' configurations"
        Log:trace(debug.traceback())
    end
end

return plugin_loader
