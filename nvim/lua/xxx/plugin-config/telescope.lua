-- local Log = require("xxx.core.log")
local M = {}

local pickers = {
    find_files = {
        theme = "dropdown",
        hidden = true,
        previewer = false,
    },
    live_grep = {
        --@usage don't include the filename in the search results
        only_sort_text = true,
        theme = "dropdown",
    },
    grep_string = {
        only_sort_text = true,
        theme = "dropdown",
    },
    buffers = {
        theme = "dropdown",
        previewer = false,
        initial_mode = "normal",
    },
    planets = {
        show_pluto = true,
        show_moon = true,
    },
    git_files = {
        theme = "dropdown",
        hidden = true,
        previewer = false,
        show_untracked = true,
    },
    lsp_references = {
        theme = "dropdown",
        initial_mode = "normal",
    },
    lsp_definitions = {
        theme = "dropdown",
        initial_mode = "normal",
    },
    lsp_declarations = {
        theme = "dropdown",
        initial_mode = "normal",
    },
    lsp_implementations = {
        theme = "dropdown",
        initial_mode = "normal",
    },
}

local actions = require "telescope.actions"
-- Define this minimal config so that it's available if telescope is not yet available.
M.opts = {
    defaults = {
        prompt_prefix = " ",
        -- selection_caret = " ",
        selection_caret = " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            width = 0.75,
            preview_cutoff = 120,
            horizontal = {
                preview_width = function(_, cols, _)
                    if cols < 120 then
                        return math.floor(cols * 0.5)
                    end
                    return math.floor(cols * 0.6)
                end,
                mirror = false,
            },
            vertical = { mirror = false },
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
        },
        mappings = {
            i = {
                -- ["<C-n>"] = actions.move_selection_next,
                -- ["<C-p>"] = actions.move_selection_previous,
                -- ["<C-c>"] = actions.close,
                ["<C-j>"] = actions.cycle_history_next,
                ["<C-k>"] = actions.cycle_history_prev,
                -- ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                -- ["<CR>"] = actions.select_default,
                -- ["<C-d>"] = require("telescope.actions").delete_buffer,
            },
            n = {
                -- ["<C-n>"] = actions.move_selection_next,
                -- ["<C-p>"] = actions.move_selection_previous,
                -- ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["dd"] = require("telescope.actions").delete_buffer,
            },
        },
        pickers = pickers,
        file_ignore_patterns = {},
        path_display = { "smart" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    },
    pickers = pickers,
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
    },

}

local function load_extension(name)
    local ok = pcall(function()
        require("telescope").load_extension(name)
    end)

    if not ok then
        vim.notify("telescope load extension '" .. name .. "' failed.", vim.log.levels.WARN, { title = "Telescope" })
    end
end

function M.setup()
    local previewers = require "telescope.previewers"
    local sorters = require "telescope.sorters"
    -- local actions = require "telescope.actions"

    local opts = vim.tbl_extend("keep", {
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        file_sorter = sorters.get_fuzzy_file,
        generic_sorter = sorters.get_generic_fuzzy_sorter,
        ---@usage Mappings are fully customizable. Many familiar mapping patterns are setup as defaults.
        -- mappings = {
        --     i = {
        --         ["<C-n>"] = actions.move_selection_next,
        --         ["<C-p>"] = actions.move_selection_previous,
        --         ["<C-c>"] = actions.close,
        --         ["<C-j>"] = actions.cycle_history_next,
        --         ["<C-k>"] = actions.cycle_history_prev,
        --         ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        --         ["<CR>"] = actions.select_default + actions.center,
        --     },
        --     n = {
        --         ["<C-n>"] = actions.move_selection_next,
        --         ["<C-p>"] = actions.move_selection_previous,
        --         ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        --         ["dd"] = require("telescope.actions").delete_buffer,
        --     },
        -- },
    }, M.opts)

    -- vim.cmd [[autocmd User TelescopePreviewerLoaded setlocal wrap]]

    vim.api.nvim_create_autocmd("User", {
        pattern = "TelescopePreviewerLoaded",
        command = "setlocal wrap",
    })

    local telescope = require "telescope"
    telescope.setup(opts)


    load_extension "notify"
    load_extension "projects"
    load_extension "fzf"

    -- require("telescope").load_extension "projects"

    -- require("telescope").load_extension "notify"

    -- require("telescope").load_extension "fzf"

end

return M
