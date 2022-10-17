local M = {}

local colors = require("xxx.plugin-config.colorscheme.colors").colors()
local vi_mode_utils = require("feline.providers.vi_mode")

-- local com_bg = "#33373E"
-- local com_bg = "#2E323B"
local com_bg = colors.statusline_bg
-- local com_bg = "#282c34"
-- local com_bg = "#22252C"

M.filetypes_to_mask = {
    "^aerial$",
    "^neo--tree$",
    "^neo--tree--popup$",
    "^NvimTree$",
    "^toggleterm$",
    "^lspsagaoutline$",
    "^mason$"
}

-- local function hide_in_width()
--     return vim.api.nvim_win_get_width(0) > 80
-- end

local function mask_plugin()
    return find_pattern_match(M.filetypes_to_mask, vim.bo.filetype)
end

M.filler = {
    hl = {
        fg = com_bg,
        bg = colors.bg,
    }
}

M.vi_mode = {
    provider = function()
        return " " .. vi_mode_utils.get_vim_mode() .. " "
    end,
    icon = "",
    hl = function()
        return {
            name = vi_mode_utils.get_mode_highlight_name(),
            fg = colors.bg,
            bg = vi_mode_utils.get_mode_color(),
        }
    end,
    right_sep = {
        {
            str = "slant_right",
            hl = function()
                return {
                    fg = vi_mode_utils.get_mode_color(),
                    bg = colors.bg,
                }
            end,
        }
    },
    priority = 100,

}

local left_section_left_sep = {
    str = "slant_left_2",
    hl = {
        fg = com_bg,
        bg = "None"
    }
}

local left_section_right_sep = {
    str = "slant_right",
    hl = {
        fg = com_bg,
        bg = "None"
    }
}

M.file_info = {
    provider = function()
        local file = require("feline.providers.file").file_info({ icon = "" },
            { type = "short", file_readonly_icon = " " })

        -- print(file, vim.bo.filetype)
        if mask_plugin() then
            file = vim.bo.filetype
        end

        return " " .. file .. " "
    end,
    icon = "",
    -- enabled = hide_in_width,
    hl = {
        fg = colors.gray,
        bg = com_bg,
    },
    left_sep = left_section_left_sep,
    right_sep = left_section_right_sep,
    priority = 100,
}

local provider_git = require("xxx.plugin-config.statusline.feline.providers.git")

-- Common function used by the git providers
M.git = {
    provider = provider_git.git_provider,
    enabled = function()
        return provider_git.git_info_exists()
    end,
    hl = {
        -- fg = colors.gray,
        -- bg = com_bg,
        fg = "None",
        bg = "None",
    },
    left_sep = left_section_left_sep,
    right_sep = left_section_right_sep,
    truncate_hide = true,
    priority = 10,
}

local provider_lsp = require("xxx.plugin-config.statusline.feline.providers.lsp")

M.lsp_diagnostics = {
    provider = provider_lsp.diagnostics_provider,
    enabled = function()
        return provider_lsp.is_diagnostics_attached()
    end,
    hl = {
        fg = "None",
        bg = "None",
    },
    left_sep = left_section_left_sep,
    right_sep = left_section_right_sep,
    truncate_hide = true,
    priority = 10,
}

local right_section_left_sep = {
    str = "slant_left",
    hl = {
        fg = com_bg,
        bg = "None",
    }
}

local right_section_right_sep = {
    str = "slant_right_2",
    hl = {
        fg = com_bg,
        bg = "None",
    }
}

-- local right_section_right_sep_thin = {
--     str = "vertical_bar_thin",
--     hl = {
--         fg = com_bg,
--         bg = "None"
--     }
-- }

M.lsp_info = {
    provider = function()
        return provider_lsp.lsp_info_provider()
    end,
    short_provider = function()
        return ""
    end,
    hl = function()
        local fg = colors.orange
        if provider_lsp.is_lsp_info_attached() then
            fg = colors.green
        end
        return {
            fg = fg,
            bg = com_bg,
        }
    end,
    icon = {
        -- str = '  ',
        str = '  ',
        always_visible = true,
    },
    left_sep = {
        str = "slant_left",
        hl = {
            fg = com_bg,
            bg = "None",
        },
        always_visible = true,
    },
    right_sep = {
        str = "slant_right_2",
        hl = {
            fg = com_bg,
            bg = "None",
        },
        always_visible = true,
    },
    -- enabled = hide_in_width,
    truncate_hide = true,
    priority = 9,
}

M.treesitter = {
    provider = "  ",
    hl = function()
        local buf = vim.api.nvim_get_current_buf()
        local ts = vim.treesitter.highlighter.active[buf]
        local fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red
        return {
            fg = fg,
            bg = com_bg,
        }
    end,
    left_sep = right_section_left_sep,
    right_sep = right_section_right_sep,
    truncate_hide = true,
    priority = 8,
}

M.space = {
    provider = function()
        local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
        return "  " .. shiftwidth .. " "
    end,
    hl = {
        fg = colors.gray,
        bg = com_bg,
    },
    left_sep = right_section_left_sep,
    -- right_sep = right_section_right_sep_thin,
    truncate_hide = true,
    priority = 7,
}

M.file_encoding = {
    provider = function()
        return "" .. ((vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc):upper() .. " "
    end,
    hl = {
        fg = colors.gray,
        bg = com_bg,
    },
    -- right_sep = right_section_right_sep_thin,
    truncate_hide = true,
    priority = 5,
}

M.file_format = {
    provider = function()
        return "" .. ((vim.bo.fileformat ~= '' and vim.bo.fileformat) or vim.o.fileformat):upper() .. " "
    end,
    hl = {
        fg = colors.gray,
        bg = com_bg,
    },
    -- right_sep = right_section_right_sep_thin,
    truncate_hide = true,
    priority = 5,
}

M.file_type = {
    provider = function()
        local file_type, icon = require("feline.providers.file").file_type({},
            { filetype_icon = true, colored_icon = true, case = "lowercase" })
        return file_type .. " ", icon
    end,
    short_provider = function()
        local _, icon = require("feline.providers.file").file_type({},
            { filetype_icon = true, colored_icon = true, case = "lowercase" })
        return " ", icon
    end,
    hl = {
        fg = colors.gray,
        bg = com_bg,
    },
    right_sep = {
        str = "slant_right_2",
        hl = {
            fg = com_bg,
            bg = "None",
        },
        always_visible = true,
    },
    truncate_hide = true,
    priority = 6,
}

M.position = {
    provider = {
        name = "position",
        opts = {
            padding = {
                line = 2,
                col = 2,
            },
            format = " {line}:{col} "
        }
    },
    hl = {
        fg = colors.statusline_bg,
        bg = colors.green,
    },
    left_sep = {
        str = "slant_left",
        hl = {
            fg = colors.green,
            bg = "NONE",
        }
    },
}

M.line_percentage = {
    provider = function()
        local line_percentage = require("feline.providers.cursor").line_percentage()
        return " " .. line_percentage .. " "
    end,
    hl = {
        fg = colors.statusline_bg,
        bg = colors.orange,
    },
}

M.scroll_bar = {
    provider = {
        name = "scroll_bar",
        opts = {
            reverse = true,
        }
    },
    hl = {
        fg = "#FFD700",
        bg = "None",
    },
}

function M.init()
    provider_git.init {
        diff_color = {
            branch = { fg = colors.gray, bg = com_bg },
            added = { fg = colors.green, bg = com_bg },
            changed = { fg = colors.orange, bg = com_bg },
            removed = { fg = colors.red, bg = com_bg },
        },
    }
    provider_lsp.init {
        colors = {
            error = { bg = com_bg },
            warn = { bg = com_bg },
            info = { bg = com_bg },
            hint = { bg = com_bg },
            copilot = { fg = "#6CC644", bg = com_bg },
        }
    }
end

return M
