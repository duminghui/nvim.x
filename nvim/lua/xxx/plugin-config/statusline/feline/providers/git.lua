local M = {}

local icons = require("xxx.core.icons")

local use_opts = {
    symbols = {
        branch = icons.git.Branch,
        added = icons.git.BoldLineAdd,
        changed = icons.git.LineModified,
        removed = icons.git.BoldLineRemove,
    },
    diff_color = {
        branch = { fg = "white", bg = "black" },
        added = { fg = "green", bg = "black" },
        changed = { fg = "orange", bg = "black" },
        removed = { fg = "red", bg = "black" },
    },
}

local b = vim.b

function M.git_info_exists()
    return b.gitsigns_head or b.gitsigns_status_dict
end

local hls = {}

function M.git_provider()
    local gitsigns = b.gitsigns_status_dict
    if not gitsigns then
        return ""
    end
    local result = {}
    for _, name in ipairs { "branch", "added", "changed", "removed" } do
        local symbol = use_opts.symbols[name]
        if name == "branch" then
            local branch = b.gitsigns_head or ''
            table.insert(result, hls[name] .. ' ' .. symbol .. " " .. branch)
        else
            local value = gitsigns[name]
            if value and value > 0 then
                table.insert(result, hls[name] .. symbol .. " " .. value)
            end
        end
    end
    if #result > 0 then
        return table.concat(result, ' ') .. " "
    else
        return ''
    end
end

local hl_name_key = "xxx_statusline_git_"

M.init = function(opts)
    opts = opts or {}
    use_opts = vim.tbl_deep_extend("force", use_opts, opts)
    local highlight = require("xxx.utils.highlight")
    for key, color in pairs(use_opts.diff_color) do
        local hl_name = hl_name_key .. key
        local gui = color.gui
        gui = (gui ~= nil and gui ~= '') and gui or "None"
        highlight.highlight(hl_name, color.fg, color.bg, gui)
        hls[key] = "%#" .. hl_name .. "#"
    end
end

return M
