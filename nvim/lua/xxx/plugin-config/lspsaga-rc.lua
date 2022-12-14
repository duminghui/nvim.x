local M = {}

local icons = require("xxx.core.icons")

M.opts = {
  -- Options with default value
  -- "single" | "double" | "rounded" | "bold" | "plus"
  border_style = "bold",
  --the range of 0 for fully opaque window (disabled) to 100 for fully
  --transparent background. Values between 0-30 are typically most useful.
  saga_winblend = 9,
  -- when cursor in saga window you config these to move
  move_in_saga = { prev = '<C-p>', next = '<C-n>' },
  -- Error, Warn, Info, Hint
  -- use emoji like
  -- { "🙀", "😿", "😾", "😺" }
  -- or
  -- { "😡", "😥", "😤", "😐" }
  -- and diagnostic_header can be a function type
  -- must return a string and when diagnostic_header
  -- is function type it will have a param `entry`
  -- entry is a table type has these filed
  -- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
  -- diagnostic_header = { " ", " ", " ", "ﴞ " },
  diagnostic_header = {
    icons.diagnostics.BoldError .. " ",
    icons.diagnostics.BoldWarning .. " ",
    icons.diagnostics.BoldInformation .. " ",
    icons.diagnostics.BoldHint .. " ",
  },
  -- preview lines of lsp_finder and definition preview
  max_preview_lines = 10,
  -- use emoji lightbulb in default
  code_action_icon = "💡",
  -- if true can press number to execute the codeaction in codeaction window
  code_action_num_shortcut = true,
  -- same as nvim-lightbulb but async
  code_action_lightbulb = {
    enable = true,
    enable_in_insert = true,
    cache_code_action = true,
    sign = false,
    update_time = 150,
    sign_priority = 20,
    virtual_text = true,
  },
  -- finder icons
  finder_icons = {
    def = '  ',
    ref = '諭 ',
    link = '  ',
  },
  -- finder do lsp request timeout
  -- if your project big enough or your server very slow
  -- you may need to increase this value
  finder_request_timeout = 1500,
  finder_action_keys = {
    open = "o",
    vsplit = "s",
    split = "i",
    tabe = "t",
    quit = "q",
  },
  code_action_keys = {
    quit = "q",
    exec = "<CR>",
  },
  definition_action_keys = {
    edit = '<C-c>o',
    vsplit = '<C-c>v',
    split = '<C-c>i',
    tabe = '<C-c>t',
    quit = 'q',
  },
  rename_action_quit = "<C-c>",
  rename_in_select = true,
  -- show symbols in winbar must nightly
  -- in_custom mean use lspsaga api to get symbols
  -- and set it to your custom winbar or some winbar plugins.
  -- if in_cusomt = true you must set in_enable to false
  symbol_in_winbar = {
    in_custom = true, -- 使用自定义可以一直显示winbar
    enable = false,
    separator = '  ',
    show_file = true,
    -- define how to customize filename, eg: %:., %
    -- if not set, use default value `%:t`
    -- more information see `vim.fn.expand` or `expand`
    -- ## only valid after set `show_file = true`
    file_formatter = "%:.",
    click_support = false,
  },
  -- show outline
  show_outline = {
    win_position = 'right',
    --set special filetype win that outline window split.like NvimTree neotree
    -- defx, db_ui
    win_with = '',
    win_width = 30,
    auto_enter = true,
    auto_preview = true,
    virt_text = '┃',
    jump_key = 'o',
    -- auto refresh when change buffer
    auto_refresh = true,
  },
  -- custom lsp kind
  -- usage { Field = 'color code'} or {Field = {your icon, your color code}}
  custom_kind = {},
  -- if you don't use nvim-lspconfig you must pass your server name and
  -- the related filetypes into this table
  -- like server_filetype_map = { metals = { "sbt", "scala" } }
  server_filetype_map = {},

}

-- Example:
local function get_file_name(include_path)
  local file_name = require('lspsaga.symbolwinbar').get_file_name()
  if vim.fn.bufname '%' == '' then return '' end
  if include_path == false then return file_name end
  -- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
  local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
  local path_list = vim.split(string.gsub(vim.fn.expand '%:~:.:h', '%%', ''), sep)
  local file_path = ''
  for _, cur in ipairs(path_list) do
    file_path = (cur == '.' or cur == '~') and '' or
        file_path .. cur .. ' ' .. '%#LspSagaWinbarSep#>%*' .. ' %*'
  end
  return file_path .. file_name
end

-- local filetype_exclude = {
--     "",
--     "dashboard",
--     'alpha',
--     'terminal',
--     'toggleterm',
--     'prompt',
--     'NvimTree',
--     'Trouble',
--     'lspsaga',
--     'lspsagaoutline',
--     'lspsagafinder',
--     'help',
--     "startify",
--     "packer",
--     "neo-tree",
--     "neogitstatus",
--     "lir",
--     "spectre_panel",
--     "DressingSelect",
--     "Jaq",
--     "harpoon",
--     "dap-repl",
--     "dap-terminal",
--     "dapui_console",
--     "lab",
--     "Markdown",
--     "mason",
--     "man",
-- } -- Ignore float windows and exclude filetype

local filetype_exclude = require("xxx.config.exclude-filetypes").lspsaga

local function config_winbar_or_statusline()
  if vim.api.nvim_win_get_config(0).zindex or vim.tbl_contains(filetype_exclude, vim.bo.filetype) then
    vim.wo.winbar = ''
  else
    local ok, lspsaga = pcall(require, 'lspsaga.symbolwinbar')
    local sym
    if ok then sym = lspsaga.get_symbol_node() end
    local win_val = ''
    win_val = get_file_name(true) -- set to true to include path
    if sym ~= nil then win_val = win_val .. sym end
    vim.wo.winbar = win_val
    -- if work in statusline
    -- vim.wo.stl = win_val
  end
end

local function set_breadcrumbs_autocmd()
  local events = { 'BufEnter', 'BufWinEnter', 'CursorMoved' }

  vim.api.nvim_create_autocmd(events, {
    pattern = '*',
    callback = function() config_winbar_or_statusline() end,
  })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspsagaUpdateSymbol',
    callback = function() config_winbar_or_statusline() end,
  })
end

function M.setup()
  local status_ok, lspsaga = safe_require("lspsaga")
  if not status_ok then
    return
  end

  if vim.fn.has "nvim-0.8" ~= 1 then
    M.opts.symbol_in_winbar.in_custom = false
    M.opts.symbol_in_winbar.enable = false
  end

  lspsaga.init_lsp_saga(M.opts)
  if M.opts.symbol_in_winbar.in_custom then
    set_breadcrumbs_autocmd()
  end
end

return M
