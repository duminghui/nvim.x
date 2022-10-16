local M = {}

local icons = require("xxx.core.icons")

local use_opts = {
    update_in_insert = false,
    symbols = {
        error = icons.diagnostics.BoldError,
        warn = icons.diagnostics.BoldWarning,
        info = icons.diagnostics.BoldInformation,
        hint = icons.diagnostics.BoldHint,
    },
    sections = { "error", "warn", "info", "hint" },
    colors = {
        error = { fg = "red", bg = "black" },
        warn = { fg = "orange", bg = "black" },
        info = { fg = "blue", bg = "black" },
        hint = { fg = "cyan", bg = "black" }
    },
}

local default_from_highlights = {
    error = "DiagnosticError",
    warn = "DiagnosticWarn",
    info = "DiagnosticInfo",
    hint = "DiagnosticHint",
}

function M.is_lsp_attached()
    return next(vim.lsp.buf_get_clients(0)) ~= nil
end

local hls = {}

local last_diagnostcis_count = {}

function M.diagnostics_provider()
    local bufnr = vim.api.nvim_get_current_buf()
    local diagnostics_count
    if use_opts.update_in_insert or vim.api.nvim_get_mode().mode:sub(1, 1) ~= "i" then
        local count = { 0, 0, 0, 0 }
        local diagnostics = vim.diagnostic.get(0)
        for _, diagnostic in ipairs(diagnostics) do
            count[diagnostic.severity] = count[diagnostic.severity] + 1
        end
        diagnostics_count = {
            error = count[vim.diagnostic.severity.ERROR],
            warn = count[vim.diagnostic.severity.WARN],
            info = count[vim.diagnostic.severity.INFO],
            hint = count[vim.diagnostic.severity.HINT],
        }
        last_diagnostcis_count[bufnr] = diagnostics_count
    else
        diagnostics_count = last_diagnostcis_count[bufnr] or { error = 0, warn = 0, info = 0, hint = 0 }
    end

    local result = {}

    for _, section in ipairs(use_opts.sections) do
        local count = diagnostics_count[section]
        if count ~= nil and count > 0 then
            local symbol = use_opts.symbols[section]
            table.insert(result, hls[section] .. ' ' .. symbol .. ' ' .. count)
        end
    end
    if #result > 0 then
        return table.concat(result, '') .. ' '
    else
        return ''
    end
end

local hl_name_key = "xxx_statusline_lsp_"
function M.init(opts)
    local highlight = require("xxx.utils.highlight")
    for type, hl in pairs(default_from_highlights) do
        local color = highlight.extract_color_from_hllist("fg", hl, use_opts.colors[type].fg)
        if color then
            use_opts.colors[type].fg = color
        end
    end
    opts = opts or {}
    use_opts = vim.tbl_deep_extend("force", use_opts, opts)

    for key, color in pairs(use_opts.colors) do
        local hl_name = hl_name_key .. key
        highlight.highlight(hl_name, color.fg, color.bg)
        hls[key] = "%#" .. hl_name .. "#"
    end

end

return M
