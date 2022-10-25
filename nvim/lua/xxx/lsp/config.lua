local skipped_servers = {
    "angularls",
    "ansiblels",
    "ccls",
    "csharp_ls",
    "cssmodules_ls",
    "denols",
    "ember",
    "emmet_ls",
    "eslint",
    "eslintls",
    "golangci_lint_ls",
    "gradle_ls",
    "graphql",
    "jedi_language_server",
    "ltex",
    "ocamlls",
    "phpactor",
    "psalm",
    "pylsp",
    "quick_lint_js",
    "reason_ls",
    "rome",
    "ruby_ls",
    "scry",
    "solang",
    "solc",
    "solidity_ls",
    "sorbet",
    "sourcekit",
    "sourcery",
    "spectral",
    "sqlls",
    "sqls",
    "stylelint_lsp",
    "svlangserver",
    "tflint",
    "verible",
    "vuels",
}

local skipped_filetypes = { "markdown", "rst", "plaintext" }

local diagnostic_float = {
    focusable = false,
    style = "minimal",
    -- border = "rounded",
    border = "single",
    source = "always",
    header = "",
    prefix = "",
    format = function(d)
        local code = d.code or (d.user_data and d.user_data.lsp.code)
        if code then
            return string.format("%s [%s]", d.message, code):gsub("1. ", "")
        end
        return d.message
    end,
}

local icons = require("xxx.core.icons")

local options = {
    templates_dir = join_paths(get_runtime_dir(), "site", "after", "ftplugin"),
    diagnostics = {
        signs = {
            values = {
                { name = "DiagnosticSignError", text = icons.diagnostics.BoldError },
                { name = "DiagnosticSignWarn", text = icons.diagnostics.BoldWarning },
                { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
                { name = "DiagnosticSignInfo", text = icons.diagnostics.BoldInformation },
            },
        },
        virtual_text = {
            -- prefix = "",
            -- spacing = 12,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = diagnostic_float,
    },
    float = {
        focusable = true,
        style = "minimal",
        border = "single",
    },
    automatic_configuration = {
        ---@usage list of servers that the automatic installer will skip
        skipped_servers = skipped_servers,
        ---@usage list of filetypes that the automatic installer will skip
        skipped_filetypes = skipped_filetypes,
    },
    buffer_mappings = {
        normal_mode = {
            ["K"] = { vim.lsp.buf.hover, "Show hover" },
            ["gd"] = { vim.lsp.buf.definition, "Goto Definition" },
            -- ["gd"] = { "<cmd>Trouble lsp_definitions<CR>", "Goto Definition" },
            ["gD"] = { vim.lsp.buf.declaration, "Goto declaration" },
            -- ["gr"] = { vim.lsp.buf.references, "Goto references" },
            ["gr"] = { "<cmd>Trouble lsp_references<CR>", "Goto references" },
            ["gI"] = { vim.lsp.buf.implementation, "Goto Implementation" },
            ["gs"] = { vim.lsp.buf.signature_help, "Show signature help" },
            ["gnr"] = { vim.lsp.buf.rename, "Rename" },
            ["gl"] = {
                function()
                    local config = diagnostic_float
                    config.scope = "line"
                    vim.diagnostic.open_float(0, config)
                end,
                "Show line diagnostics",
            },
        },
        insert_mode = {},
        visual_mode = {},
    },
    buffer_options = {
        --- enable completion triggered by <c-x><c-o>
        omnifunc = "v:lua.vim.lsp.omnifunc",
        --- use gq for formatting
        formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})",
    },

    ---@usage list of settings of mason_lspconfig
    mason_lspconfig = {
        setup = {
            ensure_installed = {},
            automatic_installation = {
                exclude = {},
            },
        },
    },

    nlsp_settings = {
        setup = {
            config_home = join_paths(get_config_dir(), "lsp-settings"),
            -- set to false to overwrite schemastore.nvim
            ignored_servers = {},
            append_default_schemas = true,
            loader = "json",
        },
    },
    null_ls = {
        setup = {
            sources = {
                require("null-ls").builtins.formatting.stylua,
            }
        },
        config = {},
    },

}
return options
