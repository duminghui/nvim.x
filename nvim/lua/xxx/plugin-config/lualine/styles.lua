local M = {}

local styles = {
    none = nil,
    default = nil,
    xxx = nil,
}

styles.none = {
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
    },
    sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    -- winbar = {},
    -- inactive_winbar = {},
    extensions = {},
}

styles.default = {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },

        --  ,   ,   ,  ,
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    -- winbar = {},
    -- inactive_winbar = {},
    extensions = {}
}

local components = require "xxx.plugin-config.lualine.components"
styles.xxx = {
    options = {
        icons_enabled = true,
        theme = 'auto',

        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = ' ', right = '' },
        -- section_separators = { left = ' ', right = ' ' },
        section_separators = { left = ' ', right = ' ' },
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = ' ', right = ' ' },
        -- component_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = {
            "alpha"
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
    },
    sections = {
        lualine_a = { components.mode },
        lualine_b = {
            components.filename,
        },
        lualine_c = {
            components.branch,
            components.diff,
            components.diagnostics,
        },
        lualine_x = {
            components.treesitter,
            components.lsp,
            components.spaces,
            components.encoding,
            "fileformat",
            components.filetype,
        },
        lualine_y = { components.location },
        lualine_z = { components.scrollbar },
    },
    inactive_sections = {
        lualine_a = { components.mode },
        lualine_b = { components.filename },
        lualine_c = {
            components.branch,
            components.diff,
            components.diagnostics,
        },
        lualine_x = {
            components.treesitter,
            components.lsp,
            components.spaces,
            components.encoding,
            "fileformat",
            components.filetype,
        },
        lualine_y = { components.location },
        lualine_z = { components.scrollbar, },
    },

    tabline = {},
    -- winbar = {},
    -- inactive_winbar = {},
    extensions = {}

}

function M.get_style(style)
    local style_keys = vim.tbl_keys(styles)
    if not vim.tbl_contains(style_keys, style) then
        print(
            "Invalid lualine style"
            .. string.format('"%s"', style)
            .. "options are: "
            .. string.format('"%s"', table.concat(style_keys, '", "')))
        print('"xvim" style is applied.')
        style = "default"
    end

    return vim.deepcopy(styles[style])
end

return M
