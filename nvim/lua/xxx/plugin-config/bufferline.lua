-- local navic = require('nvim-navic')
local colors = require("xxx.plugin-config.colorscheme.colors").colors()
local icons = require("xxx.core.icons")

local bg_color = colors.bg
local com_bg = colors.statusline_bg
local group_bg = colors.cyan
local group_label = "#FFFFFF"
local normal_fg = colors.white
local visible_fg = colors.white
local selected_fg = "#FFD700"
local pick_selected_fg = colors.purple
local duplicate_fg = colors.blue
local hint_selected_fg = colors.cyan
local info_selected_fg = colors.blue
local warning_selected_fg = colors.yellow
local error_selected_fg = colors.red
local modified_fg = colors.red
local underline_sp = colors.purple
local has_underline_indicator = false

local M = {}

local function is_ft(b, ft)
    return vim.bo[b].filetype == ft
end

-- local function diagnostics_indicator(num, _, diagnostics, _)
local function diagnostics_indicator(_, _, diagnostics, _)
    local result = {}
    local types = { "error", "warning", "info" }
    local symbols = {
        error = icons.diagnostics.BoldError,
        warning = icons.diagnostics.BoldWarning,
        info = icons.diagnostics.BoldInformation,
    }

    for _, type in ipairs(types) do
        local count = diagnostics[type]
        if count and count > 0 then
            local count_str = tostring(count)
            if count > 9 then
                count_str = "9+"
            end
            table.insert(result, symbols[type] .. '' .. count_str)
        end
    end
    return #result > 0 and table.concat(result, "") or ''
end

local function custom_filter(buf, buf_nums)
    local logs = vim.tbl_filter(function(b)
        return is_ft(b, 'log')
    end, buf_nums)
    if vim.tbl_isempty(logs) then
        return true
    end
    local tab_num = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr '$'
    local is_log = is_ft(buf, 'log')
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
    options = {
        mode = 'buffers', -- set to "tabs" to only show tabpages instead
        -- numbers = 'none', -- can be "none" | "ordinal" | "buffer_id" | "both" | function
        -- numbers = function(opts)
        --     return string.format('%s', opts.raise(opts.id))
        -- end,

        close_command = 'bdelete! %d', -- can be a string | function, see "Mouse actions"
        right_mouse_command = 'vert sbuffer %d', -- can be a string | function, see "Mouse actions"
        left_mouse_command = 'buffer %d', -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        -- indicator = {
        --     icon = '▎', -- this should be omitted if indicator style is not 'icon'
        --     style = 'underline', -- can also be 'underline'|'none',
        -- },
        indicator = "",
        buffer_close_icon = icons.ui.Close,
        modified_icon = icons.ui.Circle,
        close_icon = icons.ui.BoldClose,
        left_trunc_marker = icons.ui.ArrowCircleLeft,
        right_trunc_marker = icons.ui.ArrowCircleRight,
        --- name_formatter can be used to change the buffer's label in the bufferline.
        --- Please note some names can/will break the
        --- bufferline so use this at your discretion knowing that it has
        --- some limitations that will *NOT* be fixed.
        name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
            -- remove extension from markdown files for example
            if buf.name:match '%.md' then
                return vim.fn.fnamemodify(buf.name, ':t:r')
            end
        end,
        max_name_length = 12,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        -- truncate_names = true, -- whether or not tab names should be truncated
        tab_size = 15,
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        diagnostics_indicator = diagnostics_indicator,
        -- NOTE: this will be called a lot so don't do any heavy processing here
        custom_filter = custom_filter,
        offsets = {
            {
                filetype = 'undotree',
                text = 'Undotree',
                highlight = 'PanelHeading',
                padding = 1,
            },
            {
                filetype = 'NvimTree',
                text = 'Explorer',
                highlight = 'PanelHeading',
                padding = 1,
                -- separator = "┃",
            },
            {
                filetype = 'DiffviewFiles',
                text = 'Diff View',
                highlight = 'PanelHeading',
                padding = 1,
            },
            {
                filetype = 'flutterToolsOutline',
                text = 'Flutter Outline',
                highlight = 'PanelHeading',
            },
            {
                filetype = 'packer',
                text = 'Packer',
                highlight = 'PanelHeading',
                padding = 1,
            },
        },
        color_icons = true, -- whether or not to add the filetype icon highlights
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        -- persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = 'slant', -- slant, thin, {'any','any'}
        -- enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
            enabled = true, -- requires nvim 0.8+
            delay = 200,
            reveal = { 'close' },
        },
        -- sort_by = 'id',
        -- groups = {
        --     options = {
        --         toggle_hidden_on_enter = true,
        --     },
        --     items = {
        --         {
        --             name = "Docs",
        --             matcher = function(buf)
        --                 return buf.filename:match("%.md") or buf.filename:match("%.txt")
        --             end,
        --             -- highlight = { fg = colors.purple }, -- Optional ** color bug **
        --             separator = {
        --                 style = require("bufferline.groups").separator.pill
        --             },
        --         },
        --         {
        --             name = "Go",
        --             matcher = function(buf)
        --                 return buf.filename:match("go.mod") or buf.filename:match("%.go")
        --             end,
        --             -- highlight = { fg = "#FFD700", bg = com_bg }, -- Optional
        --             separator = {
        --                 style = require("bufferline.groups").separator.pill
        --             },
        --         }
        --     },
        -- },
    },
    highlights = {
        fill = {
            fg = bg_color,
            bg = bg_color,
        },
        group_separator = {
            fg = group_bg,
            bg = colors.bg,
        },
        group_label = {
            fg = group_label,
            bg = group_bg,
        },
        tab = {
            fg = normal_fg,
            bg = bg_color,
        },
        tab_selected = {
            fg = selected_fg,
            bg = com_bg,
            sp = underline_sp,
            underline = has_underline_indicator,
        },
        tab_close = {
            fg = normal_fg,
            bg = bg_color,
        },
        close_button = {
            fg = normal_fg,
            bg = bg_color,
        },
        close_button_visible = {
            fg = normal_fg,
            bg = com_bg,
        },
        close_button_selected = {
            fg = normal_fg,
            bg = com_bg,
            sp = underline_sp,
            underline = has_underline_indicator,
        },
        background = {
            fg = normal_fg,
            bg = bg_color,
        },
        buffer = {
            fg = normal_fg,
            bg = bg_color,
        },
        buffer_visible = {
            fg = normal_fg,
            bg = com_bg,
        },
        buffer_selected = {
            fg = selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
            sp = underline_sp,
            underline = has_underline_indicator,
        },
        numbers = {
            fg = normal_fg,
            bg = bg_color,
        },
        numbers_selected = {
            fg = selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
            sp = underline_sp,
            underline = has_underline_indicator,
        },
        numbers_visible = {
            fg = visible_fg,
            bg = com_bg,
        },
        diagnostic = {
            fg = normal_fg,
            bg = bg_color,
        },
        diagnostic_visible = {
            fg = normal_fg,
            bg = com_bg,
        },
        diagnostic_selected = {
            fg = selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
            sp = underline_sp,
            underline = has_underline_indicator,
        },
        hint = {
            fg = normal_fg,
            sp = normal_fg,
            bg = bg_color,
        },
        hint_visible = {
            fg = normal_fg,
            bg = com_bg,
        },
        hint_selected = {
            fg = hint_selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
            underline = has_underline_indicator,
            sp = underline_sp,
        },
        hint_diagnostic = {
            fg = normal_fg,
            sp = underline_sp,
            bg = bg_color,
        },
        hint_diagnostic_visible = {
            fg = normal_fg,
            bg = com_bg,
        },
        hint_diagnostic_selected = {
            fg = hint_selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
            underline = has_underline_indicator,
            sp = underline_sp,
        },
        info = {
            fg = normal_fg,
            sp = underline_sp,
            bg = bg_color,
        },
        info_visible = {
            fg = normal_fg,
            bg = com_bg,
        },
        info_selected = {
            fg = info_selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
            underline = has_underline_indicator,
            sp = underline_sp,
        },
        info_diagnostic = {
            fg = normal_fg,
            sp = underline_sp,
            bg = bg_color,
        },
        info_diagnostic_visible = {
            fg = normal_fg,
            bg = com_bg,
        },
        info_diagnostic_selected = {
            fg = info_selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
            underline = has_underline_indicator,
            sp = underline_sp,
        },
        warning = {
            fg = normal_fg,
            sp = underline_sp,
            bg = bg_color,
        },
        warning_visible = {
            fg = normal_fg,
            bg = com_bg,
        },
        warning_selected = {
            fg = warning_selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
            underline = has_underline_indicator,
            sp = underline_sp,
        },
        warning_diagnostic = {
            fg = normal_fg,
            sp = underline_sp,
            bg = bg_color,
        },
        warning_diagnostic_visible = {
            fg = normal_fg,
            bg = com_bg,
        },
        warning_diagnostic_selected = {
            fg = warning_selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
            underline = has_underline_indicator,
            sp = underline_sp,
        },
        error = {
            fg = normal_fg,
            bg = bg_color,
            sp = underline_sp,
        },
        error_visible = {
            fg = normal_fg,
            bg = com_bg,
        },
        error_selected = {
            fg = error_selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
            underline = has_underline_indicator,
            sp = underline_sp,
        },
        error_diagnostic = {
            fg = normal_fg,
            bg = bg_color,
            sp = underline_sp,
        },
        error_diagnostic_visible = {
            fg = normal_fg,
            bg = com_bg,
        },
        error_diagnostic_selected = {
            fg = error_selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
            underline = has_underline_indicator,
            sp = underline_sp,
        },
        modified = {
            fg = normal_fg,
            bg = bg_color,
        },
        modified_visible = {
            fg = normal_fg,
            bg = com_bg,
        },
        modified_selected = {
            fg = modified_fg,
            bg = com_bg,
            sp = underline_sp,
            underline = has_underline_indicator,
        },
        duplicate_selected = {
            fg = duplicate_fg,
            italic = true,
            bg = com_bg,
            sp = underline_sp,
            underline = has_underline_indicator,
        },
        duplicate_visible = {
            fg = normal_fg,
            italic = true,
            bg = bg_color,
        },
        duplicate = {
            fg = normal_fg,
            italic = true,
            bg = bg_color,
        },
        separator_selected = {
            fg = bg_color,
            bg = com_bg,
            sp = underline_sp,
            underline = has_underline_indicator,
        },
        separator_visible = {
            fg = bg_color,
            bg = com_bg,
        },
        separator = {
            fg = bg_color,
            bg = bg_color,
        },
        tab_separator = {
            fg = bg_color,
            bg = bg_color,
        },
        tab_separator_selected = {
            fg = com_bg,
            bg = bg_color,
            sp = underline_sp,
            underline = has_underline_indicator,
        },
        indicator_selected = {
            fg = bg_color,
            bg = com_bg,
            sp = underline_sp,
            underline = has_underline_indicator,
        },
        indicator_visible = {
            fg = bg_color,
            bg = com_bg,
        },
        pick_selected = {
            fg = pick_selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
            sp = underline_sp,
            underline = has_underline_indicator,
        },
        pick_visible = {
            fg = pick_selected_fg,
            bg = com_bg,
            bold = true,
            italic = true,
        },
        pick = {
            fg = pick_selected_fg,
            bg = bg_color,
            bold = true,
            italic = true,
        },
        offset_separator = {
            fg = colors.green,
            bg = com_bg,
        },
    },
}


M.setup = function()
    local status_ok, bufferline = safe_require('bufferline')
    if not status_ok then
        return
    end
    bufferline.setup(M.opts)
end

return M
