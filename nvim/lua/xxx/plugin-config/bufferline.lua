-- local navic = require('nvim-navic')

local M = {}

local function is_ft(b, ft)
    return vim.bo[b].filetype == ft
end

local function diagnostics_indicator(num, _, diagnostics, _)
    local result = {}
    local symbols = { error = "", warning = "", info = "" }
    for name, count in pairs(diagnostics) do
        if symbols[name] and count > 0 then
            table.insert(result, symbols[name] .. " " .. count)
        end
    end
    result = table.concat(result, " ")
    return #result > 0 and result or ""
end

local function custom_filter(buf, buf_nums)
    local logs = vim.tbl_filter(function(b)
        return is_ft(b, "log")
    end, buf_nums)
    if vim.tbl_isempty(logs) then
        return true
    end
    local tab_num = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr "$"
    local is_log = is_ft(buf, "log")
    if last_tab == 1 then
        return true
    end
    -- only show log buffers in secondary tabs
    return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
end

M.opts = {
    -- keymap = {
    --     normal_mode = {},
    -- },
    highlights = {
        background = {
            italic = true,
        },
        buffer_selected = {
            bold = true,
        },
        fill = {
            bg = '#202328'
        },
        indicator_selected = {
            fg = '#51afef'
        }
    },
    options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        -- numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
        numbers = function(opts)
            return string.format('%s', opts.raise(opts.id))
        end,

        close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
        right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        indicator = {
            icon = "▎", -- this should be omitted if indicator style is not 'icon'
            style = "icon", -- can also be 'underline'|'none',
        },
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        --- name_formatter can be used to change the buffer's label in the bufferline.
        --- Please note some names can/will break the
        --- bufferline so use this at your discretion knowing that it has
        --- some limitations that will *NOT* be fixed.
        name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
            -- remove extension from markdown files for example
            if buf.name:match "%.md" then
                return vim.fn.fnamemodify(buf.name, ":t:r")
            end
        end,
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        truncate_names = true, -- whether or not tab names should be truncated
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = diagnostics_indicator,
        -- NOTE: this will be called a lot so don't do any heavy processing here
        custom_filter = custom_filter,
        offsets = {
            {
                filetype = "undotree",
                text = "Undotree",
                highlight = "PanelHeading",
                padding = 1,
            },
            {
                filetype = "NvimTree",
                text = "Explorer",
                highlight = "PanelHeading",
                padding = 1,
            },
            {
                filetype = "DiffviewFiles",
                text = "Diff View",
                highlight = "PanelHeading",
                padding = 1,
            },
            {
                filetype = "flutterToolsOutline",
                text = "Flutter Outline",
                highlight = "PanelHeading",
            },
            {
                filetype = "packer",
                text = "Packer",
                highlight = "PanelHeading",
                padding = 1,
            },
        },
        color_icons = true, -- whether or not to add the filetype icon highlights
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = "thin",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
            enabled = false, -- requires nvim 0.8+
            delay = 200,
            reveal = { "close" },
        },
        sort_by = "id",
    },


    -- options = {
    --     -- show bufferline when buffer size > 1
    --     always_show_bufferline = true,
    --     mode = "buffers", -- set to "tabs" to only show tabpages instead
    --     numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
    --     numbers = function(opts)
    --         return string.format('%s', opts.raise(opts.id))
    --     end,
    --     indicator = {
    --         icon = "▎", -- this should be omitted if indicator style is not 'icon'
    --         style = "icon" -- can also be 'icon'|'underline'|'none',
    --     },
    --     show_buffer_icons = true,
    --     show_close_icon = true,
    --     show_buffer_close_icons = true,
    --     diagnostics = "nvim_lsp",
    --     diagnostics_indicator = function(count, level, diagnostics_dict,
    --                                      context)
    --         local s = " "
    --         for e, n in pairs(diagnostics_dict) do
    --             local sym = e == "error" and "" or
    --                 (e == "warning" and "" or "")
    --             s = s .. sym .. n
    --         end
    --         return s
    --     end,
    --     custom_areas = {
    --         -- right = function()
    --         --     local result = {}
    --         --     if navic.is_available() then
    --         --         table.insert(result, {
    --         --             text = navic.get_location() .. ' ',
    --         --             fg = "#a9a1e1",
    --         --             bg = '#202328'
    --         --         })
    --         --     end
    --         --     return result
    --         -- end
    --     },
    --     hover = {
    --         enabled = false, -- requires nvim 0.8+
    --         delay = 200,
    --         reveal = { "close" },
    --     },
    --     sort_by = "id",
    -- },
    -- highlights = {
    --     fill = {
    --         -- fg = '#282c34',
    --         bg = '#202328'
    --     },
    --     indicator_selected = {
    --         fg = '#51afef'
    --         -- bg = '#282c34'
    --     }
    -- }

}


M.setup = function()
    --   vim.pretty_print(M.opts)
    require "bufferline".setup(M.opts)
end

return M
