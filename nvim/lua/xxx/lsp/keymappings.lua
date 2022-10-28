local M = {}

local lsp_opts = require "xxx.lsp.config"

function M.add_lsp_buffer_keybindings(client, bufnr)
    local not_null_ls = client.name ~= "null-ls"
    local can_format = false
    if not not_null_ls then
        local filetype = vim.bo.filetype
        local n = require "null-ls"
        local s = require "null-ls.sources"
        local method = n.methods.FORMATTING
        local avalable_formatters = s.get_available(filetype, method)
        can_format = #avalable_formatters > 0
    else
        can_format = client.server_capabilities.documentFormattingProvider
    end
    local keymaps = {
        ["K"] = { vim.lsp.buf.hover, "[LSP]Show hover", not_null_ls },

        ["gd"] = { vim.lsp.buf.definition, "[LSP]Goto definition", not_null_ls },
        -- ["gd"] = { "<cmd>Trouble lsp_definitions<CR>", "Goto definition" },
        ["gD"] = { "<cmd>Lspsaga peek_definition<CR>", "[LSP]Peek definition", not_null_ls },

        ["gt"] = { vim.lsp.buf.type_definition, "[LSP]Goto type definition",
            not_null_ls and client.server_capabilities.typeDefinitionProvider },

        -- ["gf"] = { vim.lsp.buf.declaration, "[LSP]Goto declaration", not_null_ls },

        -- ["gr"] = { vim.lsp.buf.references, "Goto references" },
        ["gr"] = { "<cmd>Trouble lsp_references<CR>", "[LSP]Goto references", not_null_ls },

        ["gI"] = { vim.lsp.buf.implementation, "[LSP]Goto implementation",
            not_null_ls and client.server_capabilities.implementationProvider },

        ["gs"] = { vim.lsp.buf.signature_help, "[LSP]Show signature help",
            not_null_ls and client.supports_method("textDocument/signatureHelp") },

        ["gnr"] = { vim.lsp.buf.rename, "[LSP]Rename", not_null_ls and client.supports_method("textDocument/rename") },

        ["gl"] = {
            function()
                local config = lsp_opts.diagnostics.float
                config.scope = "line"
                vim.diagnostic.open_float(0, config)
            end,
            "[LSP]Show line diagnostics",
            not_null_ls
        },

        ["gL"] = { vim.lsp.codelens.run, "[LSP]Code lens", not_null_ls and client.server_capabilities.codeLensProvider },

        -- F code_action
        ["[d"] = { vim.diagnostic.goto_prev, "[LSP]Prev Diagnostic", not_null_ls },
        ["]d"] = { vim.diagnostic.goto_next, "[LSP]Next Diagnostic", not_null_ls },

        ["<LocalLeader>lf"] = {
            function()
                require("xxx.lsp.utils").format({})
            end,
            "[LSP]Format",
            can_format,
        }
    }

    for key, remap in pairs(keymaps) do
        if remap[3] then
            local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = false }
            vim.keymap.set("n", key, remap[1], opts)
        end
    end
end

return M
