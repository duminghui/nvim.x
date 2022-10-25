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

require "xxx.core.globals"

-- 全局
require "xxx.config.config"

local bootstrap = require("xxx.bootstrap")
-- 配置rpt

bootstrap:init_rtp(root_dir, nvim_base_dir)

local config = require("xxx.config")

config.init()

bootstrap:init_plugin_loader()

config.load()

--插件配置
local plugins = require "xxx.plugins"
require("xxx.plugin-loader").load { plugins = plugins }

local Log = require "xxx.core.log"
Log:debug "Starting XVim"


local commands = require "xxx.core.commands"
commands.load(commands.defaults)

-- --Lsp配置
require("xxx.lsp").setup()

-- local ProgressNotify = require("xxx.core.progress-notify")
-- local notif = ProgressNotify:new()
-- vim.defer_fn(function()
--     notif:start("this is a test", "This is a test")
--     vim.defer_fn(function()
--         notif:finish("This is end", "warn", "XX")
--     end, 2000)
-- end, 1000)
