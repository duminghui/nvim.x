-- $XDG_DATA_HOME会影响rtp, 主要影响nvim-data的路径
-- \nvim-data\site

-- \nvim-data\site\after

-- \Local\nvim.x\nvim\init.lua
local init_path = debug.getinfo(1, "S").source:sub(2)
-- \local\nvim.x\nvim
local nvim_base_dir = init_path:match("(.*[/\\])"):sub(0, -2)

if not vim.tbl_contains(vim.opt.rtp:get(), nvim_base_dir) then
    vim.opt.rtp:append(nvim_base_dir)
end

-- \local\nvim.x
local root_dir = nvim_base_dir:match("(.*[/\\])"):sub(1, -2)

-- 全局
require "xxx.config.g"

-- 配置rpt
require("xxx.bootstrap"):init(root_dir, nvim_base_dir)

-- 基本配置
require("xxx.config"):load()

--插件配置
local plugins = require "xxx.plugins"
require("xxx.plugin-loader").load { plugins }

local Log = require "xxx.core.log"
Log:debug "Starting XVim"


local commands = require "xxx.core.commands"
commands.load(commands.defaults)

-- --Lsp配置
require("xxx.lsp").setup()


-- vim.pretty_print(vim.opt.rtp:get())
