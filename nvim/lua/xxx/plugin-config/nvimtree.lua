local M = {}

local function telescope_find_files(_)
    require("xxx.plugin-config.nvimtree").start_telescope "find_files"
end

local function telescope_live_grep(_)
    require("xxx.plugin-config.nvimtree").start_telescope "live_grep"
end

M.opts = {
    ignore_ft_on_setup = {
        "startify",
        "dashboard",
        "alpha",
    },
    auto_reload_on_write = true,
    hijack_directories = {
        enable = false,
    },
    update_cwd = true,
    diagnostics = {
        enable = true,
        show_on_dirs = false,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
    },
    system_open = {
        cmd = nil,
        args = {},
    },
    git = {
        enable = true,
        ignore = false,
        timeout = 200,
    },
    view = {
        width = 30,
        hide_root_folder = false,
        side = "left",
        mappings = {
            custom_only = false,
            list = {
                { key = { "l", "<CR>", "o" }, action = "edit", mode = "n" },
                { key = "h", action = "close_node" },
                { key = "v", action = "vsplit" },
                { key = "C", action = "cd" },
                { key = "gtf", action = "telescope_find_files", action_cb = telescope_find_files },
                { key = "gtg", action = "telescope_live_grep", action_cb = telescope_live_grep },
            },
        },
        number = false,
        relativenumber = false,
        signcolumn = "yes",
    },
    renderer = {
        indent_markers = {
            enable = false,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                none = " ",
            },
        },
        icons = {
            webdev_colors = true,
            show = {
                git = true,
                folder = true,
                file = true,
                folder_arrow = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                git = {
                    unstaged = "",
                    staged = "S",
                    unmerged = "",
                    renamed = "➜",
                    deleted = "",
                    -- untracked = "U",
                    untracked = "",
                    ignored = "◌",
                },
                folder = {
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                },
            },
        },
        highlight_git = true,
        root_folder_modifier = ":t",
    },
    filters = {
        dotfiles = false,
        custom = { "node_modules", "\\.cache" },
        exclude = {},
    },
    trash = {
        cmd = "trash",
        require_confirm = true,
    },
    log = {
        enable = false,
        truncate = false,
        types = {
            all = false,
            config = false,
            copy_paste = false,
            diagnostics = false,
            git = false,
            profile = false,
        },
    },
    actions = {
        use_system_clipboard = true,
        change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
        },
        open_file = {
            quit_on_open = false,
            resize_window = false,
            window_picker = {
                enable = true,
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                    filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                    buftype = { "nofile", "terminal", "help" },
                },
            },
        },
    },
}


M.nvimtree_setup_called = false

M.setup = function()
    local status_ok, nvim_tree = pcall(require, "nvim-tree")
    if not status_ok then
        Log:error "Failed to load nvim-tree"
        return
    end

    local status_ok_1, utils = pcall(require, "nvim-tree.utils")
    if not status_ok_1 then
        return
    end

    local function notify_level()
        return function(msg)
            vim.schedule(function()
                vim.api.nvim_echo({ { msg, "WarningMsg" } }, false, {})
            end)
        end
    end

    utils.notify.warn = notify_level(vim.log.levels.WARN)
    utils.notify.error = notify_level(vim.log.levels.ERROR)
    utils.notify.info = notify_level(vim.log.levels.INFO)
    utils.notify.debug = notify_level(vim.log.levels.DEBUG)

    if M.nvimtree_setup_called then
        Log:debug "ignoring repeated setup call for nvim-tree, see kyazdani42/nvim-tree.lua#1308"
        return
    end

    -- lvim.builtin.which_key.mappings["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" }
    M.nvimtree_setup_called = true

    -- Implicitly update nvim-tree when project module is active
    M.opts.respect_buf_cwd = true
    M.opts.update_cwd = true
    M.opts.update_focused_file = { enable = true, update_cwd = true }


    nvim_tree.setup(M.opts)
end

function M.start_telescope(telescope_mode)
    local node = require("nvim-tree.lib").get_node_at_cursor()
    local abspath = node.link_to or node.absolute_path
    local is_folder = node.open ~= nil
    local basedir = is_folder and abspath or vim.fn.fnamemodify(abspath, ":h")
    require("telescope.builtin")[telescope_mode] {
        cwd = basedir,
        theme = "cursor"
    }
end

return M
