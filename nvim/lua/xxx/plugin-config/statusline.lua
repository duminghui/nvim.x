local M = {}

M.filetypes_to_mask = {
    "^aerial$",
    "^neo--tree$",
    "^neo--tree--popup$",
    "^NvimTree$",
    "^toggleterm$",
}

M.force_inactive = {
    filetypes = {
        "^alpha$",
        "^frecency$",
        "^packer$",
        "^TelescopePrompt$",
        "^undotree$",
    },
}

M.disable = {
    filetypes = {
        "^alpha$",
        "^dap-repl$",
        "^dapui_scopes$",
        "^dapui_stacks$",
        "^dapui_breakpoints$",
        "^dapui_watches$",
        "^DressingInput$",
        "^DressingSelect$",
        "^floaterm$",
        "^minimap$",
        "^qfs$",
        "^tsplayground$",
    },
}

local function using_session()
    return vim.g.persising ~= nil
end

local function mask_plugin()
    return find_pattern_match(M.filetypes_to_mask, vim.bo.filetype)
end

local function get_icon(filename, extension, opts)
    local devicons = require("nvim-web-devicons")

    local icon_str, icon_color = devicons.get_icon_color(filename, extension, { default = true })

    local icon = { str = icon_str }

    if opts.colored_icon ~= false then
        icon.hl = { fg = icon_color }
    end
    return icon
end

local function statusline_components()

    -- local lsp = require("feline.providers.lsp")
    local git = require("feline.providers.git")
    local vi_mode_utils = require("feline.providers.vi_mode")

    local colors = require("onedarkpro").get_colors(vim.g.onedarkpro_theme)
    if not colors then
        return {}
    end


    local function default_hl()
        return {
            fg = colors.grey,
            bg = "NONE",
        }
    end

    local function block(bg, fg)
        if not bg then
            bg = colors.bg_statusline
        end
        if not fg then
            fg = colors.gray
        end
        return {
            body = {
                fg = fg,
                bg = bg,
            },
            sep_left = {
                fg = colors.bg,
                bg = bg,
            },
            sep_right = {
                fg = bg,
                bg = colors.bg,
            },
        }
    end

    local function inverse_block()
        return {
            body = {
                fg = colors.bg,
                bg = colors.gray,
            },
            sep_left = {
                fg = colors.bg,
                bg = colors.gray,
            },
            sep_right = {
                fg = colors.gray,
                bg = colors.bg,
            },
        }
    end

    local function line_percentage()
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local percent = string.format("%s", 100)

        if curr_line ~= lines then
            percent = string.format("%s", math.ceil(curr_line / lines * 99))
        end

        return lines, percent
    end

    local function line_col()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local col = vim.api.nvim_win_get_cursor(0)[2]

        return row .. ":" .. col
    end

    local c_vi_mode = {
        provider = function()
            return require("feline.providers.vi_mode").get_vim_mode() .. " "
        end,
        icon = "",
        hl = function()
            return {
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

    local c_git = {
        provider = function()
            -- local gitsigns = vim.b.gitsigns_status_dict
            return "  " .. require("feline.providers.git").git_branch() .. " "
        end,
        truncate_hide = true,
        enabled = function()
            return git.git_info_exists()
        end,
        hl = function()
            return block().body
        end,
        left_sep = {
            str = "slant_right",
            hl = function()
                return block().sep_left
            end,
        },
        right_sep = {
            str = "slant_right",
            -- hl = {
            --     fg = "#FFFF00",
            --     bg = "#FF0000"
            -- }
            hl = function()
                return block().sep_right
            end,
        },
        show_mode_name = true,
        padding = false,
    }

    local c_fileinfo = {
        provider = function()
            local file = require("feline.providers.file").file_info({ icon = "" }, { type = "short" })

            if mask_plugin() then
                file = vim.bo.filetype
            end

            return " " .. file .. " "
        end,
        enabled = function()
            return vim.api.nvim_win_get_width(0) > 80
        end,

        hl = function()
            return block().body
        end,
        left_sep = {
            str = "slant_right",
            hl = function()
                return block().sep_left
            end,
        },
        right_sep = {
            str = "slant_right",
            hl = function()
                return block().sep_right
            end,
        },
    }

    local c_diagnostic_errors = {
        provider = "diagnostic_errors",
        icon = " ",
        hl = function()
            return block(colors.red, colors.bg).body
        end,
        left_sep = {
            str = "slant_right",
            hl = function()
                return block(colors.red, colors.bg).sep_left
            end,
        },
        right_sep = {
            str = "slant_right",
            hl = function()
                return block(colors.red).sep_right
            end,
        },
        show_mode_name = true,
        padding = false,
    }

    local c_diagnostic_warnings = {
        provider = "diagnostic_warnings",
        icon = " ",
        hl = function()
            return block(colors.yellow, colors.bg).body
        end,
        left_sep = {
            str = "slant_right",
            hl = function()
                return block(colors.yellow).sep_left
            end,
        },
        right_sep = {
            str = "slant_right",
            hl = function()
                return block(colors.yellow).sep_right
            end,
        },
    }

    local c_diagnostic_hints = {
        provider = "diagnostic_hints",
        icon = " ",
        hl = function()
            return default_hl()
        end,
        left_sep = {
            str = " ",
            hl = function()
                return default_hl()
            end,
        },
        right_sep = {
            str = " ",
            hl = function()
                return default_hl()
            end,
        },
    }

    local c_diagnostic_info = {
        provider = "diagnostic_info",
        icon = " ",
        hl = function()
            return default_hl()
        end,
        left_sep = {
            str = " ",
            hl = function()
                return default_hl()
            end,
        },
        right_sep = {
            str = " ",
            hl = function()
                return default_hl()
            end,
        },
    }

    local c_filler = {
        hl = function()
            return default_hl()
        end
    }

    local c_filetype = {
        provider = function()
            local filename = vim.api.nvim_buf_get_name(0)
            local extension = vim.fn.fnamemodify(filename, ":e")
            local filetype = vim.bo.filetype

            local icon = get_icon(filename, extension, {})
            return " " .. icon.str .. " " .. filetype .. " "
        end,
        enabled = function()
            return not mask_plugin() and vim.api.nvim_win_get_width(0) > 80
        end,
        hl = function()
            return block().body
        end,
        left_sep = {
            str = "slant_left",
            hl = function()
                return block().sep_right
            end,
        },
        right_sep = {
            str = "slant_left",
            hl = function()
                return block().sep_left
            end,
        },

    }

    local c_session = {
        provider = function()
            if vim.g.persisting then
                return "   "
            elseif vim.g.persisting == false then
                return "   "
            end
        end,
        enabled = function()
            return using_session()
        end,
        hl = function()
            return block().body
        end,
        left_sep = {
            str = "slant_left",
            hl = function()
                return block().sep_right
            end,
        },
        right_sep = {
            str = "slant_left",
            hl = function()
                return block().sep_left
            end,
        },

    }

    local c_line_column = {
        provider = function()
            return " " .. line_col() .. " "
        end,
        enabled = function()
            return vim.api.nvim_win_get_width(0) > 80
        end,
        hl = function()
            return inverse_block().body
        end,
        left_sep = {
            str = "slant_left",
            hl = function()
                return inverse_block().sep_right
            end,
        },
        right_sep = {
            str = "slant_left",
            hl = function()
                return inverse_block().sep_left
            end,
        },
    }

    local c_line_percentage = {
        provider = function()
            local lines, percent = line_percentage()

            return " " .. percent .. "%%/" .. lines
        end,
        hl = function()
            return inverse_block().body
        end,
        left_sep = {
            str = "slant_left",
            hl = function()
                return inverse_block().sep_right
            end,
        },
        right_sep = {
            str = " ",
            hl = function()
                return inverse_block().body
            end,
        },
    }




    local components = { active = {}, inactive = {} }

    components.active = {
        {
            c_vi_mode,
            c_fileinfo,
            c_git,
            { provider = "git_diff_added", hl = { fg = colors.green, bg = "NONE", }, padding = false },
            { provider = "git_diff_removed", hl = { fg = colors.red, bg = "NONE", }, },
            { provider = "git_diff_changed", hl = { fg = colors.orange, bg = "NONE", }, },
            c_diagnostic_errors,
            c_diagnostic_warnings,
            c_diagnostic_hints,
            c_diagnostic_info,
            c_filler,
        },
        {
            c_filetype,
            c_session,
            c_line_column,
            c_line_percentage,
            -- { provider = "scroll_bar" },
        },
    }

    local InactiveStatusHL = {
        fg = colors.bg_statusline,
        bg = "NONE",
        style = "underline",
    }

    components.inactive = { { { provider = "", hl = InactiveStatusHL } } }


    return components
end

-- local function winbar_components()
--     local winbar_components = { active = {}, inactive = {} }

--     local colors = require("onedarkpro").get_colors(vim.g.onedarkpro_theme)
--     if not colors then
--         return winbar_components
--     end

--     local navic_ok, navic = safe_require("nvim-navic")
--     if navic_ok then
--         winbar_components.active[1] = {
--             provider = function()
--                 return navic.get_location()
--             end,
--             enabled = function()
--                 return navic.is_available()
--             end,
--             hl = {
--                 fg = colors.grey,
--                 bg = "NONE",
--             }
--         }

--     end
--     return winbar_components
-- end

local function opts_with_empty_components()
    local opts = {
        -- theme = {
        --     fg = "NONE",
        --     bg = "NONE",
        -- },
        disable = M.disable,
        force_inactive = M.force_inactive,
        components = {
            active = {},
            inactive = { { { provider = "" } } },
        },
    }
    local ok, onedarkpro = pcall(require, "onedarkpro")
    if not ok then
        return opts
    end
    local colors = onedarkpro.get_colors(vim.g.onedarkpro_theme)
    if not colors then
        vim.schedule(function()
            vim.notify("onedarkpro get_colors failed", vim.log.levels.ERROR)
        end)
        return opts
    end
    opts.vi_mode_colors = {
        NORMAL = colors.purple,
        OP = colors.purple,
        INSERT = colors.green,
        VISUAL = colors.orange,
        LINES = colors.orange,
        BLOCK = colors.orange,
        REPLACE = colors.green,
        ["V-REPLACE"] = colors.green,
        ENTER = colors.cyan,
        MORE = colors.cyan,
        SELECT = colors.orange,
        COMMAND = colors.purple,
        SHELL = colors.purple,
        TERM = colors.purple,
        NONE = colors.yellow,
    }
    return opts
end

function M.setup()
    local ok, feline = safe_require("feline")
    if not ok then
        return
    end
    -- local opts, winbar_opts = M.opts()
    local opts = opts_with_empty_components()
    opts.components = statusline_components()
    feline.setup(opts)
    -- local winbar_opts = {
    --     components = winbar_components()
    -- }
    -- feline.winbar.setup(winbar_opts)
end

return M
