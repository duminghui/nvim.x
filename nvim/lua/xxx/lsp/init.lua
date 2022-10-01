local M = {}
local Log = require "xxx.core.log"
local autocmds = require "xxx.core.autocmds"

local utils = require("xxx.utils")
local opts = require "xxx.lsp.config"


local function add_lsp_buffer_options(bufnr)
    for k, v in pairs(opts.buffer_options) do
        vim.api.nvim_buf_set_option(bufnr, k, v)
    end
end

local function add_lsp_buffer_keybindings(bufnr)
    local mappings = {
        normal_mode = "n",
        insert_mode = "i",
        visual_mode = "v",
    }
    for mode_name, mode_char in pairs(mappings) do
        for key, remap in pairs(opts.buffer_mappings[mode_name]) do
            local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
            vim.keymap.set(mode_char, key, remap[1], opts)
        end
    end
end

local function handlers_setup()
    local config = {
        virtual_text = opts.diagnostics.virtual_text,
        signs = opts.diagnostics.signs,
        underline = opts.diagnostics.underline,
        update_in_insert = opts.diagnostics.update_in_insert,
        severity_sort = opts.diagnostics.severity_sort,
        float = opts.diagnostics.float,
    }
    vim.diagnostic.config(config)

    local float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
    }

    -- illuminate not active
    -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float)
end

function M.common_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    }

    local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if status_ok then
        capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
    end

    return capabilities
end

function M.common_on_exit(_, _)
    -- print("common_on_exit")
    autocmds.clear_augroup "lsp_document_highlight"
    autocmds.clear_augroup "lsp_code_lens_refresh"
end

function M.common_on_init(client, bufnr)
    -- print("common_on_init")
end

function M.common_on_attach(client, bufnr)
    -- print("common_on_attach")
    local lu = require "xxx.lsp.utils"

    -- setup_document_highlight can delete
    lu.setup_document_highlight(client, bufnr)

    lu.setup_codelens_refresh(client, bufnr)
    add_lsp_buffer_keybindings(bufnr)
    add_lsp_buffer_options(bufnr)
    lu.setup_document_symbols(client, bufnr)

end

function M.get_common_opts()
    return {
        on_attach = M.common_on_attach,
        on_init = M.common_on_init,
        on_exit = M.common_on_exit,
        capabilities = M.common_capabilities(),
    }
end

function M.setup()
    Log:debug "Setting up LSP support"
    local lsp_status_ok, lspconfig = pcall(require, "lspconfig")
    if not lsp_status_ok then
        Log:debug "LSP: lspconfig not ok"
    end

    require('lspconfig.ui.windows').default_options.border = 'single'
    -- local hl_name = "NormalFloat"
    -- require('lspconfig.ui.windows').default_options.border = {
    --     { "╭", hl_name },
    --     { "─", hl_name },
    --     { "╮", hl_name },
    --     { "│", hl_name },
    --     { "╯", hl_name },
    --     { "─", hl_name },
    --     { "╰", hl_name },
    --     { "│", hl_name },
    -- }

    -- diagnostics
    for _, sign in ipairs(opts.diagnostics.signs.values) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
    end

    handlers_setup()


    if not utils.is_directory(opts.templates_dir) then
        require("xxx.lsp.templates").generate_templates(opts.templates_dir)
    end


    require("nlspsettings").setup(opts.nlsp_settings.setup)

    pcall(function()
        require("mason-lspconfig").setup(opts.mason_lspconfig.setup)
        local util = require "lspconfig.util"
        -- automatic_installation is handled by lsp-manager
        util.on_setup = nil
    end)

    require("xxx.lsp.null-ls").setup()

    autocmds.configure_format_on_save(true)
end

return M
