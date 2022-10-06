local M = {}

M.opts = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false, -- adds help for operators like d, y, ...
            motions = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = false, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
        spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        -- separator = "➜", -- symbol used between a key and it's label
        separator = " ", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
}

M.v_opts = {
    mode = "v", -- VISUAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

M.v_mappings = {
    -- ["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },
}

M.n_opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

M.n_mappings = {
    [";"] = { "<cmd>Alpha<CR>", "Dashboard" },
    ["w"] = { "<cmd>w!<CR>", "Save" },
    ["c"] = { "<cmd>BufferKill<CR>", "Close Buffer" },
    ["q"] = { "<cmd>lua require('xxx.utils.functions').smart_quit()<CR>", "Quit" },
    ["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
    ["f"] = { require("xxx.plugin-config.telescope.custom-finders").find_project_files, "Find File" },
    ["N"] = { "<cmd>Notifications<CR>", "Notifications" },
    ["r"] = { "<cmd>PrintRtp<CR>", "Print runtimepath" },
    -- ["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
    -- ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
    ["/"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
    b = {
        name = "Buffers",
        j = { "<cmd>BufferLinePick<cr>", "Jump" },
        f = { "<cmd>Telescope buffers<cr>", "Find" },
        p = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
        n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
        -- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
        e = { "<cmd>BufferLinePickClose<cr>", "Pick which buffer to close", },
        h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
        l = { "<cmd>BufferLineCloseRight<cr>", "Close all to the right", },
        D = { "<cmd>BufferLineSortByDirectory<cr>", "Sort by directory", },
        L = { "<cmd>BufferLineSortByExtension<cr>", "Sort by language", },
    },
    p = {
        name = "Packer",
        c = { "<cmd>PackerCompile<CR>", "Compile" },
        i = { "<cmd>PackerInstall<CR>", "Install" },
        r = { "<cmd>lua require 'xxx.plugin-loader'.recompile()<CR>", "Re-compile" },
        s = { "<cmd>PackerSync<CR>", "Sync" },
        S = { "<cmd>PackerStatus<CR>", "Status" },
        u = { "<cmd>PackerUpdate<CR>", "Update" },
    },
    g = {
        name = "Git",
        g = { "<cmd>lua require 'xxx.plugin-config.terminal'.lazygit_toggle()<CR>", "Lazygit" },
        j = { "<cmd>lua require 'gitsigns'.next_hunk()<CR>", "Next Hunk" },
        k = { "<cmd>lua require 'gitsigns'.prev_hunk()<CR>", "Prev Hunk" },
        l = { "<cmd>lua require 'gitsigns'.blame_line()<CR>", "Blame" },
        p = { "<cmd>lua require 'gitsigns'.preview_hunk()<CR>", "Preview Hunk" },
        r = { "<cmd>lua require 'gitsigns'.reset_hunk()<CR>", "Reset Hunk" },
        R = { "<cmd>lua require 'gitsigns'.reset_buffer()<CR>", "Reset Buffer" },
        s = { "<cmd>lua require 'gitsigns'.stage_hunk()<CR>", "Stage Hunk" },
        u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<CR>", "Undo Stage Hunk" },
        o = { "<cmd>Telescope git_status<CR>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<CR>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<CR>", "Checkout commit" },
        C = { "<cmd>Telescope git_bcommits<CR>", "Checkout commit(for current file)" },
        d = { "<cmd>Gitsigns diffthis HEAD<CR>", "Git Diff" },
    },
    l = {
        name = "LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
        d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
        w = { "<cmd>Telescope diagnostics<CR>", "Diagnostics" },
        f = { require("xxx.lsp.utils").format, "Format" },
        i = { "<cmd>LspInfo<CR>", "Lsp Info" },
        I = { "<cmd>Mason<CR>", "Mason Info" },
        j = { vim.diagnostic.goto_next, "Next Diagnostic", },
        k = { vim.diagnostic.goto_prev, "Prev Diagnostic", },
        l = { vim.lsp.codelens.run, "CodeLens Action" },
        q = { vim.diagnostic.setloclist, "Quickfix" },
        r = { vim.lsp.buf.rename, "Rename" },
        s = { "<cmd> Telescope lsp_document_symbols<CR>", "Document Symbols" },
        S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Workspace Symbols" },
        e = { "<cmd>Telescope quickfix<CR>", "Telescope Quickfix" },
    },
    s = {
        name = "Search",
        -- b = { "<cmd>Telescope git_branches<CR>", "Checkout branch" },
        c = { "<cmd>Telescope colorscheme<CR>", "Colorscheme" },
        f = { "<cmd>Telescope find_files<CR>", "Find File" },
        h = { "<cmd>Telescope help_tags<CR>", "Find Help" },
        H = { "<cmd>Telescope highlights<CR>", "Find highlight groups" },
        M = { "<cmd>Telescope man_pages<CR>", "Man Pages" },
        r = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" },
        R = { "<cmd>Telescope registers<CR>", "Registers" },
        t = { "<cmd>Telescope live_grep<CR>", "Text" },
        k = { "<cmd>Telescope keymaps<CR>", "Keymaps" },
        C = { "<cmd>Telescope commands<CR>", "Commands" },
        p = { "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<CR>",
            "Colorscheme with Preview" }
    },
    T = {
        name = "Treesitter",
        i = { ":TSConfigInfo<CR>", "Info" },
        m = { ":TSModuleInfo<CR>", "Module Info" }
    },
    X = {
        name = "+XVim",
        f = { "<cmd>lua require('xxx.plugin-config.telescope.custom-finders').find_xvim_files()<CR>", "Find XVim files" },
        g = { "<cmd>lua require('xxx.plugin-config.telescope.custom-finders').grep_xvim_files()<CR>", "Grep XVim files" },
        k = { "<cmd>Telescope keymaps<CR>", "Keymapings" },
        i = { "<cmd>lua require('xxx.core.info').toggle_popup(vim.bo.filetype)<CR>", "Toggle XVim Info" },
        l = {
            name = "+logs",
            d = { "<cmd>lua require('xxx.plugin-config.terminal').toggle_log_view(require('xxx.core.log').get_path())<CR>",
                "View default log" },
            D = { "<cmd>lua vim.fn.execute('edit ' .. require('xxx.core.log').get_path())<CR>", "Open the default log" },
            l = { "<cmd>lua require('xxx.plugin-config.terminal').toggle_log_view(vim.lsp.get_log_path())<CR>",
                "View LSP log" },
            L = { "<cmd>lua vim.fn.execute('edit ' .. vim.lsp.get_log_path())<CR>", "Open the LSP logfile" },
            n = { "<cmd>lua require('xxx.plugin-config.terminal').toggle_log_view(os.getenv('NVIM_LOG_FILE'))<CR>",
                "View Neovim log" },
            N = { "<cmd>edit $NVIM_LOG_FILE<CR>", "Open the Neovim logfile" },
            p = { "<cmd>lua require('xxx.plugin-config.terminal').toggle_log_view(get_cache_dir() .. '/packer.nvim.log')<CR>",
                "View Packer log" },
            P = { "<cmd>lua vim.fn.execute('edit ' .. get_cache_dir() .. '/packer.nvim.log')<CR>",
                "Open the Packer logfile" }
        },
        n = { "<cmd>Telescope notify<cr>", "View Notifications" },
    },

}


M.setup = function()
    local which_key = require "which-key"
    which_key.setup(M.opts)
    which_key.register(M.n_mappings, M.n_opts)
end

return M
