local M = {}

local colors = require("xxx.plugin-config.colorscheme.colors").colors()
local vi_mode_utils = require("feline.providers.vi_mode")

-- local com_bg = "#33373E"
local com_bg = "#2E323B"

M.filetypes_to_mask = {
    "^aerial$",
    "^neo--tree$",
    "^neo--tree--popup$",
    "^NvimTree$",
    "^toggleterm$",
}
local function hide_in_width()
    return vim.api.nvim_win_get_width(0) > 80
end

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
    priority = 100,
    -- left_sep = {
    --     str = "vertical_bar_thin",
    --     hl = function()
    --         return {
    --             fg = vi_mode_utils.get_mode_color(),
    --             bg = vi_mode_utils.get_mode_color(),
    --         }
    --     end,
    -- },
    right_sep = {
        -- {
        --     str = "vertical_bar_thin",
        --     hl = function()
        --         return {
        --             fg = vi_mode_utils.get_mode_color(),
        --             bg = vi_mode_utils.get_mode_color(),
        --         }
        --     end

        -- },
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

}

local left_section_left_sep = {
    str = "slant_left_2",
    hl = {
        fg = com_bg,
        bg = colors.bg,
    }
}

local left_section_right_sep = {
    str = "slant_right",
    hl = {
        fg = com_bg,
        bg = colors.bg,
    }
}

M.file_info = {
    provider = function()
        local file = require("feline.providers.file").file_info({ icon = "" },
            { type = "short", file_readonly_icon = " " })

        if mask_plugin() then
            file = vim.bo.filetype
        end

        return " " .. file .. " "
    end,
    -- provider = {
    --     name = "file_info",
    --     opts = {
    --         colored_icon = false,
    --         file_readonly_icon = " ",
    --     },
    -- },
    icon = "",
    -- enabled = hide_in_width,
    hl = {
        fg = colors.gray,
        bg = com_bg,
    },
    left_sep = left_section_left_sep,
    right_sep = left_section_right_sep,
}

local provider_git = require("xxx.plugin-config.statusline.feline.providers.git")

-- Common function used by the git providers
M.git = {
    provider = provider_git.git_provider,
    enabled = function()
        return vim.b.gitsigns_head or vim.b.gitsigns_status_dict
    end,
    truncate_hide = true,
    hl = {
        fg = com_bg,
        bg = com_bg,
    },
    left_sep = left_section_left_sep,
    right_sep = left_section_right_sep,
}

local provider_lsp = require("xxx.plugin-config.statusline.feline.providers.lsp")

M.lsp_diagnostics = {
    provider = provider_lsp.diagnostics_provider,
    enabled = function()
        return provider_lsp.is_diagnostics_attached()
    end,
    hl = {
        fg = com_bg,
        bg = com_bg,
    },
    left_sep = left_section_left_sep,
    right_sep = left_section_right_sep,
}

local right_section_left_sep = {
    str = "slant_left",
    hl = {
        fg = com_bg,
        bg = colors.bg,
    }
}

local right_section_right_sep = {
    str = "slant_right_2",
    hl = {
        fg = com_bg,
        bg = colors.bg,
    }
}

local right_section_right_sep_thin = {
    str = "vertical_bar_thin",
    hl = {
        fg = com_bg,
        bg = colors.bg,
    }
}

M.lsp_info = {
    provider = provider_lsp.lsp_info_provider,
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
    left_sep = right_section_left_sep,
    right_sep = right_section_right_sep,
    icon = '  LSP:',
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
}

M.file_format = {
    provider = function()
        return "" .. ((vim.bo.fileformat ~= '' and vim.bo.fileformat) or vim.o.fileformat):upper() .. " "
    end,
    truncate_hide = true,
    hl = {
        fg = colors.gray,
        bg = com_bg,
    },
    -- right_sep = right_section_right_sep_thin,
}

M.file_type = {
    provider = function()
        local file_type, icon = require("feline.providers.file").file_type({},
            { filetype_icon = true, colored_icon = true, case = "lowercase" })
        return file_type .. " ", icon
    end,
    hl = {
        fg = colors.gray,
        bg = com_bg,
    },
    -- right_sep = right_section_right_sep_thin,
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
