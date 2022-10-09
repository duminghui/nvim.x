-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}

function M.setup(lsp_opts)
    local config = { -- your config
        virtual_text = lsp_opts.diagnostics.virtual_text,
        signs = lsp_opts.diagnostics.signs,
        underline = lsp_opts.diagnostics.underline,
        update_in_insert = lsp_opts.diagnostics.update_in_insert,
        severity_sort = lsp_opts.diagnostics.severity_sort,
        float = lsp_opts.diagnostics.float,
    }
    vim.diagnostic.config(config)
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, lsp_opts.float)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, lsp_opts.float)
end

return M
