local colors = require("xxx.plugin-config.colorscheme.colors").colors()
local icons = require("xxx.core.icons")

local com_bg = colors.statusline_bg

local left_sep_both = {
    left = "",
    right = "",
}

local right_seq_both = {
    left = "",
    right = "",
}

local M = {}

M.empty = { "empty", color = { fg = "None", bg = "None" } }

M.mode = {
    "mode",
    separator = {
        right = "",
    }
}

M.filename = {
    "filename",
    color = { fg = colors.gray, bg = com_bg },
    newfile_status = true,
    symbols = {
        modified = icons.ui.Circle,
        readonly = icons.ui.Lock2,
        unnamed = '[No Name]',
        newfile = icons.ui.NewFile,
    },
    separator = left_sep_both,
}


M.branch = {
    "git_branch",
    color = { fg = colors.gray, bg = com_bg },
    icon = icons.git.Branch,
    separator = left_sep_both,
}

local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end

M.diff = {
    'diff',
    source = diff_source,
    symbols = {
        added = icons.git.BoldLineAdd .. " ",
        modified = icons.git.LineModified .. " ",
        removed = icons.git.BoldLineRemove .. " ",
    },
    diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.yellow },
        removed = { fg = colors.red },
    },
    cond = nil,
    colored = true,
    padding = {
        left = 0,
        right = 1,
    },
    color = { bg = com_bg },
    separator = left_sep_both,
}

M.diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
        error = icons.diagnostics.BoldError .. " ",
        warn = icons.diagnostics.BoldWarning .. " ",
        info = icons.diagnostics.BoldInformation .. " ",
        hint = icons.diagnostics.BoldHint .. " ",
    },
    color = { bg = com_bg },
    separator = left_sep_both,
}

M.treesitter = {
    function()
        return icons.ui.Tree
    end,
    color = function()
        local buf = vim.api.nvim_get_current_buf()
        local ts = vim.treesitter.highlighter.active[buf]
        return {
            fg = ts and not vim.tbl_isempty(ts) and colors.blue or colors.red,
            bg = com_bg,
        }
    end,
    separator = right_seq_both,
}

local function is_lsp_client_attached()
    return next(vim.lsp.get_active_clients({ bufnr = 0 })) ~= nil
end

M.lsp_clients = {
    "lsp_clients",
    clients = {
        copilot = { symbol = icons.git.Octoface, color = { fg = "#6CC644", bg = com_bg } }
    },
    icons = {
        active = icons.ui.LspActive,
        inactive = icons.ui.LspInactive,
    },
    icon = nil,
    color = function()
        return {
            fg = is_lsp_client_attached() and colors.green or colors.orange,
            bg = com_bg,
        }
    end,
    separator = right_seq_both,
}


local function is_in_session()
    return require("session_manager.utils").is_session
end

M.session_status = {
    function()
        return is_in_session() and icons.ui.CloudCheck or icons.ui.CloudOff
    end,
    color = function()
        return {
            fg = is_in_session() and colors.green or colors.red,
            bg = com_bg,
        }
    end,
    separator = right_seq_both,
}

M.file_info = {
    "file_info",
    color = { fg = colors.gray, bg = com_bg },
    separator = right_seq_both,
}

local right_seq_left = {
    left = "",
}

M.location = {
    "location",
    color = { fg = colors.bg, bg = colors.green },
    separator = right_seq_left,
}

M.progress = {
    "file_progress",
    color = { fg = colors.bg, bg = colors.orange },
}

M.scrollbar = {
    "file_scrollbar",
    color = { fg = "#FFD700", bg = "None" },
    padding = 0,
}

local constants = require("overseer.constants")
local STATUS = constants.STATUS

M.overseer = {
    "overseer",
    symbols = {
        [STATUS.FAILURE] = icons.diagnostics.BoldError,
        [STATUS.CANCELED] = icons.diagnostics.BoldInformation,
        [STATUS.SUCCESS] = icons.ui.BoldCircleCheck,
        [STATUS.RUNNING] = icons.ui.Run,
    },
    color = { fg = colors.gray, bg = com_bg },
    icons_enabled = true,
    separator = right_seq_both,
}

return M
