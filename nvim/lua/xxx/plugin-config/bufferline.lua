-- local navic = require('nvim-navic')
local colors = require("xxx.plugin-config.colorscheme.colors").colors()
local icons = require("xxx.core.icons")

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
        numbers = 'none', -- can be "none" | "ordinal" | "buffer_id" | "both" | function
        -- numbers = function(opts)
        --     return string.format('%s', opts.raise(opts.id))
        -- end,

        close_command = 'bdelete! %d', -- can be a string | function, see "Mouse actions"
        right_mouse_command = 'vert sbuffer %d', -- can be a string | function, see "Mouse actions"
        left_mouse_command = 'buffer %d', -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        -- indicator = {
        --     icon = '▎', -- this should be omitted if indicator style is not 'icon'
        --     style = 'icon', -- can also be 'underline'|'none',
        -- },
        indicator = "",
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
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
                -- padding = 1,
                separator = "┃",
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
        -- show_tab_indicators = true,
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
    },
    -- highlights = {
    --     background = {
    --         italic = true,
    --     },
    --     buffer_selected = {
    --         bold = true,
    --     },
    --     fill = {
    --         bg = '#202328'
    --     },
    --     indicator_selected = {
    --         fg = '#51afef'
    --     }
    -- },
    highlights = {
        fill = {
            -- fg = '<colour-value-here>',
            bg = colors.bg,
        },
        background = {
            -- fg = '<colour-value-here>',
            bg = colors.bg,
        },
        tab = {
            fg = colors.gray,
            bg = colors.bg,
        },
        tab_selected = {
            fg = colors.fg,
            bg = colors.statusline_bg,
        },
        tab_close = {
            -- fg = '<colour-value-here>',
            bg = colors.bg,
        },
        close_button = {
            -- fg = '<colour-value-here>',
            bg = colors.bg,
        },
        close_button_visible = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
        },
        close_button_selected = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
        },
        buffer_visible = {
            fg = colors.gray,
            bg = colors.statusline_bg,
            bold = true,
            italic = true,
        },
        buffer_selected = {
            fg = colors.bufferline_text_focus,
            bg = colors.statusline_bg,
            bold = true,
            italic = true,
        },
        numbers = {
            fg = colors.gray,
            bg = colors.bg,
        },
        numbers_visible = {
            fg = colors.gray,
            bg = colors.statusline_bg,
        },
        numbers_selected = {
            fg = colors.purple,
            bg = colors.statusline_bg,
            bold = false,
            italic = true,
        },
        diagnostic = {
            -- fg = '<colour-value-here>',
            bg = colors.bg,
        },
        diagnostic_visible = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
        },
        diagnostic_selected = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
            -- bold = true,
            -- italic = true,
        },
        hint = {
            -- fg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            bg = colors.bg,
        },
        hint_visible = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
        },
        hint_selected = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
            -- sp = '<colour-value-here>',
            -- bold = true,
            -- italic = true,
        },
        hint_diagnostic = {
            -- fg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            bg = colors.bg,
        },
        hint_diagnostic_visible = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
        },
        hint_diagnostic_selected = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
            -- sp = '<colour-value-here>',
            -- bold = true,
            -- italic = true,
        },
        info = {
            -- fg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            bg = colors.bg,
        },
        info_visible = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
        },
        info_selected = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
            -- sp = '<colour-value-here>',
            -- bold = true,
            -- italic = true,
        },
        info_diagnostic = {
            -- fg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            bg = colors.bg,
        },
        info_diagnostic_visible = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
        },
        info_diagnostic_selected = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
            -- sp = '<colour-value-here>',
            -- bold = true,
            -- italic = true,
        },
        warning = {
            -- fg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            bg = colors.bg,
        },
        warning_visible = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
        },
        warning_selected = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
            -- sp = '<colour-value-here>',
            -- bold = true,
            --     italic = true,
        },
        warning_diagnostic = {
            -- fg = '<colour-value-here>',
            -- sp = '<colour-value-here>',
            bg = colors.bg,
        },
        warning_diagnostic_visible = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
        },
        warning_diagnostic_selected = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
            -- sp = warning_diagnostic_fg,
            -- bold = true,
            -- italic = true,
        },
        error = {
            -- fg = '<colour-value-here>',
            bg = colors.bg,
            -- sp = '<colour-value-here>'
        },
        error_visible = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
        },
        error_selected = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
            -- sp = '<colour-value-here>',
            bold = false,
            italic = false,
        },
        error_diagnostic = {
            -- fg = '<colour-value-here>',
            bg = colors.bg,
            -- sp = '<colour-value-here>'
        },
        error_diagnostic_visible = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
        },
        error_diagnostic_selected = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
            -- sp = '<colour-value-here>',
            bold = false,
            italic = false,
        },
        modified = {
            fg = colors.gray,
            bg = colors.bg,
        },
        modified_visible = {
            fg = colors.gray,
            bg = colors.statusline_bg,
        },
        modified_selected = {
            fg = colors.red,
            bg = colors.statusline_bg,
        },
        duplicate_selected = {
            -- fg = colors.purple,
            fg = colors.blue,
            bg = colors.statusline_bg,
            italic = true,
        },
        duplicate_visible = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
            italic = true,
        },
        duplicate = {
            fg = colors.gray,
            bg = colors.bg,
            italic = true,
        },
        separator_selected = {
            fg = colors.bg,
            bg = colors.statusline_bg,
        },
        separator_visible = {
            -- fg = '<colour-value-here>',
            fg = colors.bg,
            bg = colors.statusline_bg,
        },
        separator = {
            fg = colors.bg,
            bg = colors.bg,
        },
        indicator_visible = {
            bg = colors.statusline_bg,
        },
        indicator_selected = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
        },
        pick_selected = {
            fg = colors.gray,
            bg = colors.statusline_bg,
            bold = true,
            italic = false,
        },
        pick_visible = {
            -- fg = '<colour-value-here>',
            bg = colors.statusline_bg,
            bold = true,
            italic = true,
        },
        pick = {
            fg = colors.purple,
            bg = colors.bg,
            -- bold = true,
            -- italic = true,
        },
        offset_separator = {
            -- fg = win_separator_fg,
            bg = colors.statusline_bg,
        },
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
    local status_ok, bufferline = safe_require('bufferline')
    if not status_ok then
        return
    end
    bufferline.setup(M.opts)
end

return M
