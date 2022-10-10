local Log = require "xxx.core.log"
local join_paths = require("xxx.utils").join_paths

local M = {}

M.opts = {
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    parser_install_dir = join_paths(get_runtime_dir(), "parsers"),
    ensure_installed = { 'lua' },
    sync_install = false,
    auto_install = false,
    ignore_install = {},
    matchup = {
        enable = false, -- mandatory, false will disable the whole extension
        -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
    },
    highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = true,
        disable = { "latex" },
    },
    incremental_selection = {
        enable = false,
    },
    indent = {
        enable = true,
        disable = { "yaml", "python" }
    },
    autotag = { enable = false },
    textobjects = {
        swap = {
            enable = false,
            -- swap_next = textobj_swap_keymaps,
        },
        -- move = textobj_move_keymaps,
        select = {
            enable = false,
            -- keymaps = textobj_sel_keymaps,
        },
    },
    textsubjects = {
        enable = false,
        keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
    },
    playground = {
        enable = false,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
        },
    },
}

M.setup = function()
    -- avoid running in headless mode since it's harder to detect failures
    if #vim.api.nvim_list_uis() == 0 then
        Log:debug "headless mode detected, skipping running setup for treesitter"
        return
    end

    local status_ok, configs = safe_require("nvim-treesitter.configs")
    if not status_ok then
        Log:error "Failed to load nvim-treesitter.configs"
        return
    end

    local opts = vim.deepcopy(M.opts)

    -- 这个一定要放在setup前面
    vim.opt.runtimepath:append(M.opts.parser_install_dir)

    configs.setup(opts)
    -- 其他的配置有 autopairs, rainbow, ts-context-commentstring,

end

return M
