local conditions = require "xxx.plugin-config.lualine.conditions"
local colors = require "xxx.plugin-config.lualine.colors"
-- local color_hex = require "xxx.utils".color_hex

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

-- local statusline_hl = vim.api.nvim_get_hl_by_name("StatusLine", true)
-- local cursorline_hl = vim.api.nvim_get_hl_by_name("CursorLine", true)
-- local normal_hl = vim.api.nvim_get_hl_by_name("Normal", true)

-- local slprogress = vim.api.nvim_get_hl_by_name("SLProgress", true)
-- vim.pretty_print(slprogress)

local location_color = nil
-- local branch = ""
local branch = ""

-- local separator = "│"

-- if xvim.colorscheme == "tokyonight" then
--     location_color = "SLBranchName"
--     branch = "%#SLGitIcon#" .. "" .. "%*" .. "%#SLBranchName#"

--     local status_ok, tnc = pcall(require, "tokyonight.colors")
--     if status_ok then
--         local tncolors = tnc.setup { transform = true }
--         vim.api.nvim_set_hl(0, "SLSeparator", { fg = cursorline_hl.background, bg = tncolors.black })
--         separator = "%#SLSeparator#" .. "│" .. "%*"
--     end
-- end


return {

    set_highlight = function()
        local statusline_hl = vim.api.nvim_get_hl_by_name("StatusLine", true)
        local cursorline_hl = vim.api.nvim_get_hl_by_name("CursorLine", true)
        local normal_hl = vim.api.nvim_get_hl_by_name("Normal", true)
        vim.api.nvim_set_hl(0, "SLGitIcon", { fg = "#E8AB53", bg = cursorline_hl.background })
        vim.api.nvim_set_hl(0, "SLBranchName", { fg = normal_hl.foreground, bg = cursorline_hl.background })
        vim.api.nvim_set_hl(0, "SLProgress", { fg = "#ECBE7B", bg = statusline_hl.background })
    end,

    divide = {
        function()
            return " "
        end,
        padding = { left = 0, right = 0 },
    },

    mode        = {
        function()
            return "  "
        end,
        padding = { left = 0, right = 0 },
        color = {},
        cond = nil,
    },
    branch      = {
        "b:gitsigns_head",
        icon = branch,
        color = { gui = "bold" },
    },
    filename    = {
        "filename",
        color = {},
        cond = nil,
    },
    diff        = {
        "diff",
        source = diff_source,
        symbols = { added = " ", modified = " ", removed = " " },
        padding = { left = 0, right = 0 },
        diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed = { fg = colors.red },
        },
        cond = nil,
    },
    python_env  = {
        function()
            local utils = require "xxx.plugin-config.lualine.utils"
            if vim.bo.filetype == "python" then
                local venv = os.getenv "CONDA_DEFAULT_ENV" or os.getenv "VIRTUAL_ENV"
                if venv then
                    return string.format("  (%s)", utils.env_cleanup(venv))
                end
            end
            return ""
        end,
        color = { fg = colors.green },
        cond = conditions.hide_in_width,
    },
    diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " ", hint = " " },
        padding = { left = 2, right = 2 },
        cond = conditions.hide_in_width,
    },
    treesitter  = {
        function()
            return ""
        end,
        color = function()
            local buf = vim.api.nvim_get_current_buf()
            local ts = vim.treesitter.highlighter.active[buf]
            return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.orange }
        end,
        padding = { right = 1 },
        cond = conditions.hide_in_width,
    },
    lsp         = {
        function(msg)
            msg = msg or "Inactive"
            local buf_clients = vim.lsp.buf_get_clients()
            if next(buf_clients) == nil then
                -- TODO: clean up this if statement
                if type(msg) == "boolean" or #msg == 0 then
                    return "Inactive"
                end
                return msg
            end

            local buf_ft = vim.bo.filetype
            local buf_client_names = {}

            -- add client
            for _, client in pairs(buf_clients) do
                if client.name ~= "null-ls" then
                    table.insert(buf_client_names, client.name)
                end
            end
            -- add formatter
            local formatters = require "xxx.lsp.null-ls.formatters"
            local supported_formatters = formatters.list_registered(buf_ft)
            vim.list_extend(buf_client_names, supported_formatters)

            -- add linter
            local linters = require "xxx.lsp.null-ls.linters"
            local supported_linters = linters.list_registered(buf_ft)
            vim.list_extend(buf_client_names, supported_linters)

            local unique_client_names = vim.fn.uniq(buf_client_names)
            return "[" .. table.concat(unique_client_names, ", ") .. "]"
        end,
        -- separator = separator,
        icon = ' LSP:',
        -- color = { gui = "bold" },
        color = function()
            local buf_clients = vim.lsp.buf_get_clients()
            if next(buf_clients) == nil then
                return { fg = colors.orange }
            else
                return { fg = colors.green }
            end
        end,
        -- cond = conditions.hide_in_width,
    },

    -- lsp = {
    --     function()
    --         local msg = 'No Active Lsp'
    --         local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    --         local clients = vim.lsp.get_active_clients()
    --         if next(clients) == nil then
    --             return msg
    --         end
    --         local clientnames = ''
    --         for _, client in ipairs(clients) do
    --             -- local filetypes = client.config.filetypes
    --             if client.attached_buffers[vim.fn.bufnr()] ~= nil then
    --                 clientnames = clientnames .. client.name .. ' '
    --             end
    --         end
    --         if string.len(clientnames) > 0 then
    --             return string.sub(clientnames, 1, string.len(clientnames) - 1)
    --         end
    --         return msg
    --     end,
    --     icon = ' LSP:',
    --     color = { fg = colors.cyan, gui = 'bold' }
    -- },
    location = {
        "location",
        color = location_color,
        -- padding = 0

    },
    progress = {
        "progress",
        fmt = function()
            return "%P/%L"
        end,
        color = {},
    },

    spaces = {
        function()
            local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
            return " " .. shiftwidth
        end,
        -- separator = separator,
        padding = 1,
    },
    encoding = {
        "o:encoding",
        fmt = string.upper,
        color = {},
        -- separator = separator,
        cond = conditions.hide_in_width,
    },
    filetype = {
        "filetype",
        -- separator = separator,
        icon = "",
        padding = { left = 1, right = 1 },
        cond = nil,
    },
    scrollbar = {
        function()
            local current_line = vim.fn.line "."
            local total_lines = vim.fn.line "$"
            local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
            local line_ratio = current_line / total_lines
            local index = math.ceil(line_ratio * #chars)
            return chars[index]
        end,
        padding = { left = 0, right = 0 },
        color = "SLProgress",
        cond = nil,
    },
}
