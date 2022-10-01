-- $XDG_DATA_HOME会影响rtp, 主要影响nvim-data的路径
-- \nvim-data\site
-- \nvim-data\site\after

-- \Local\nvim.i\nvim\init.lua
local init_path = debug.getinfo(1, "S").source:sub(2)

-- \Local\nvim.i\nvim
local nvim_config_dir = init_path:match("(.*[/\\])"):sub(1, -2)

if not vim.tbl_contains(vim.opt.rtp:get(), nvim_config_dir) then
    vim.opt.rtp:append(nvim_config_dir)
end

-- \Local\nvim.i
local base_dir = nvim_config_dir:match("(.*[/\\])"):sub(1, -2)

-- 全局
require("xxx.g")

-- 配置rpt
require("xxx.bootstrap"):init(base_dir, nvim_config_dir)

-- 基本配置
require("xxx.config")

-- local autocmds = require "xxx.autocmds"
-- autocmds.load_defaults()


require("xxx.keymappings")

-- --插件配置
local plugins = require "xxx.plugins"
require("xxx.plugin-loader").load { plugins }

-- --Lsp配置
require("xxx.lsp").setup()


function PrintRtp()
    for k, v in pairs(vim.opt.rtp:get()) do
        print(v)
    end
end

-- vim.pretty_print(vim.opt.rtp:get())
