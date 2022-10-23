local M = {}
local Log = require "xxx.core.log"

--- Load the default set of autogroups and autocommands.
function M.load_defaults()

    vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = {
            "Jaq",
            "qf",
            -- "help",
            "man",
            "lspinfo",
            "spectre_panel",
            "lir",
            "DressingSelect",
            "tsplayground",
            -- "Markdown",
        },
        callback = function()
            vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      nnoremap <silent> <buffer> <esc> :close<CR>
      set nobuflisted
    ]]
        end,
    })

    vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = {
            "alpha",
        },
        callback = function()
            vim.cmd [[
      nnoremap <silent> <buffer> q :qa<CR>
      nnoremap <silent> <buffer> <esc> :qa<CR>
      set nobuflisted
    ]]
        end,
    })

    vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "lir" },
        callback = function()
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
        end,
    })

    -- TODO: figure out what keeps overriding laststatus
    vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        pattern = { "*" },
        callback = function()
            vim.opt.laststatus = 3 -- Use global statusline
        end,
    })

    local definitions = {
        {
            "TextYankPost",
            {
                group = "_general_settings",
                pattern = "*",
                desc = "Highlight text on yank",
                callback = function()
                    require("vim.highlight").on_yank { higroup = "Search", timeout = 100 }
                end,
            },
        },
        {
            "FileType",
            {
                group = "_filetype_settings",
                pattern = "qf",
                command = "set nobuflisted",
            },
        },
        {
            "FileType",
            {
                group = "_filetype_settings",
                pattern = { "gitcommit", "markdown" },
                command = "setlocal wrap spell",
            },
        },
        {
            "FileType",
            {
                group = "_buffer_mappings",
                pattern = {
                    "qf",
                    -- "help",
                    "man",
                    "floaterm",
                    "lspinfo",
                    "lsp-installer",
                    "null-ls-info",
                },
                command = "nnoremap <silent> <buffer> q :close<CR>",
            },
        },
        {
            { "BufWinEnter", "BufRead", "BufNewFile" },
            {
                group = "_format_options",
                pattern = "*",
                -- command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
                command = "setlocal formatoptions-=c",
            },
        },
        {
            "VimResized",
            {
                group = "_auto_resize",
                pattern = "*",
                command = "tabdo wincmd =",
            },
        },
    }

    M.define_autocmds(definitions)
end

function M.enable_format_on_save()
    local opts = {
        ---@usage pattern string pattern used for the autocommand (Default: '*')
        pattern = "*",
        ---@usage timeout number timeout in ms for the format request (Default: 1000)
        timeout = 1000,
        -- ---@usage filter func to select client
        -- filter = require("xxx.lsp.utils").format_filter,
    }
    vim.api.nvim_create_augroup("lsp_format_on_save", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = "lsp_format_on_save",
        pattern = opts.pattern,
        callback = function()
            require("xxx.lsp.utils").format { timeout_ms = opts.timeout, filter = opts.filter }
        end,
    })
    Log:debug "enabled format-on-save"
end

function M.disable_format_on_save()
    M.clear_augroup "lsp_format_on_save"
    Log:debug "disabled format-on-save"
end

function M.configure_format_on_save(enable)
    if enable then
        M.enable_format_on_save()
    else
        M.disable_format_on_save()
    end
end

function M.toggle_format_on_save()
    local exists, autocmds = pcall(vim.api.nvim_get_autocmds, {
        group = "lsp_format_on_save",
        event = "BufWritePre",
    })
    if not exists or #autocmds == 0 then
        M.enable_format_on_save()
    else
        M.disable_format_on_save()
    end
end

function M.enable_transparent_mode()
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
            local hl_groups = {
                "Normal",
                "SignColumn",
                "NormalNC",
                "TelescopeBorder",
                "NvimTreeNormal",
                "EndOfBuffer",
                "MsgArea",
            }
            for _, name in ipairs(hl_groups) do
                vim.cmd(string.format("highlight %s ctermbg=none guibg=none", name))
            end
        end,
    })
    vim.opt.fillchars = "eob: "
end

--- Clean autocommand in a group if it exists
--- This is safer than trying to delete the augroup itself
---@param name string the augroup name
function M.clear_augroup(name)
    -- defer the function in case the autocommand is still in-use
    Log:debug("request to clear autocmds  " .. name)
    vim.schedule(function()
        pcall(function()
            vim.api.nvim_clear_autocmds { group = name }
        end)
    end)
end

--- Create autocommand groups based on the passed definitions
--- Also creates the augroup automatically if it doesn't exist
---@param definitions table contains a tuple of event, opts, see `:h nvim_create_autocmd`
function M.define_autocmds(definitions)
    for _, entry in ipairs(definitions) do
        local event = entry[1]
        local opts = entry[2]
        if type(opts.group) == "string" and opts.group ~= "" then
            local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
            if not exists then
                vim.api.nvim_create_augroup(opts.group, {})
            end
        end
        vim.api.nvim_create_autocmd(event, opts)
    end
end

return M
