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
        return vi_mode_utils.get_vim_mode() .. " "
    end,
    icon = "",
    hl = function()
        return {
            name = vi_mode_utils.get_mode_highlight_name(),
            fg = colors.bg,
            bg = vi_mode_utils.get_mode_color(),
        }

    end,
    left_sep = {
        str = "vertical_bar_thin",
        hl = function()
            return {
                fg = vi_mode_utils.get_mode_color(),
                bg = vi_mode_utils.get_mode_color(),
            }
        end,
    },
    right_sep = {
        str = "slant_right",
        hl = function()
            return {
                fg = vi_mode_utils.get_mode_color(),
                bg = colors.bg,
            }
        end,
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
        local file = require("feline.providers.file").file_info({ icon = "" }, { type = "short" })

        if mask_plugin() then
            file = vim.bo.filetype
        end

        return " " .. file .. " "
    end,
    -- provider = "file_info",
    enabled = function()
        return vim.api.nvim_win_get_width(0) > 80
    end,
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
    -- hl = {
    --     fg = com_bg,
    --     bg = com_bg,
    -- },
    left_sep = left_section_left_sep,
    right_sep = left_section_right_sep,
}

local provider_lsp = require("xxx.plugin-config.statusline.feline.providers.lsp")

M.lsp_diagnostics = {
    provider = provider_lsp.diagnostics_provider,
    enabled = function()
        return provider_lsp.is_lsp_attached()
    end,
    hl = {
        fg = com_bg,
        bg = colors.bg
    },
    left_sep = left_section_left_sep,
    right_sep = left_section_right_sep,
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
            hint = { bg = com_bg }
        }
    }
end

return M
