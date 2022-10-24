local M = {}
local default_options = {
    -- backup = false,
    --[[if a file is being edited by another program
    (or was written to file while editing with another program), it is not allowed to be edited ]]
    -- writebackup = false,
    -- swapfile = false,
    -- undofile = true,

    -- 去除蜂鸣
    -- belloff = { 'esc', 'spell' },
    -- compatible = false,
    -- clipboard = "unnamedplus",
    -- virtualedit = 'onemore',
    -- required to keep multiple buffers and open multiple buffers
    -- Allow buffer switching without saving
    -- hidden = true,
    -- linebreak = true,
    -- breakat = "",
    -- tabpagemax = 15,
    -- showmode = true,
    -- showcmd = true,
    -- cmdheight = 2,

    -- textwidth = 80,
    -- cursorline = true,
    -- cursorcolumn = true,
    -- colorcolumn = "80,120,160",
    -- number = true,
    -- relativenumber = true,
    -- number column width
    -- numberwidth = 4,
    --- always show the sign column, otherwise it would shift the text each time
    -- signcolumn = "yes:1",
    -- guifont = "monospace:h13",

    -- wrap = true,
    -- wrapmargin = 1,
    -- breakindent = true,
    -- breakindentopt = "shift:2,sbr", -- lin wrap opts

    -- mouse = "a",
    -- for bufferline hover
    -- mousemoveevent = true,

    -- 窗口分隔线和fold线
    -- -- fillchars = 'vert:|,fold:-',
    -- fillchars = {
    --     horiz = "━",
    --     horizup = "┻",
    --     horizdown = "┳",
    --     vert = "┃",
    --     vertleft = "┫",
    --     vertright = "┣",
    --     verthoriz = "╋",
    --     fold = "-",
    -- },
    -- linespace = 0,

    -- search
    -- showmatch = true,
    -- incsearch = true,
    -- hlsearch = true,
    -- ignorecase = true,
    -- smartcase = true,

    -- pop list
    -- show list instead of just completing
    -- wildmenu = true,
    -- wildmode = "list:longest,full",

    -- foldenable = true,
    -- scrolljump = 1,
    -- scrolloff = 6,

    -- list = true,
    -- listchars = 'tab:›■,trail:•,extends:#,nbsp:.',

    -- autoindent = true,
    -- the number of spaces inserted for each identation
    -- shiftwidth = 4,
    -- convert tabs to spaces
    -- expandtab = true,
    -- insert x spaces for a tab
    -- tabstop = 4,
    -- softtabstop = 4,

    -- puts new vsplit windows to the right of the current
    -- splitright = true,
    -- put new split windows to the bottom of the current
    -- splitbelow = true,

    -- completeopt = { "menuone", "noselect" },

    -- bufferline need
    -- termguicolors = true,

    -- background = 'dark',

    -- treesitter
    -- foldmethod = "manual", -- folding, set to "expr" for treesitter based folding
    -- foldexpr = "", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
    -- sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize", -- Session options to store in the session
}

function M.load_default_options()
    -------------------- GLOBAL OPTIONS --------------------
    vim.g.mapleader = ","
    vim.g.maplocalleader = ","

    -------------------- BUFFER OPTIONS --------------------
    -- vim.bo.autoindent = true
    -- vim.bo.expandtab = true -- Use spaces instead of tabs
    -- vim.bo.shiftwidth = 4 -- Size of an indent
    -- vim.bo.smartindent = true -- Insert indents automatically
    -- vim.bo.softtabstop = 4 -- Number of spaces tabs count for **
    -- vim.bo.tabstop = 4 -- Number of spaces in a tab

    vim.opt.autoindent = true
    vim.opt.expandtab = true -- Use spaces instead of tabs
    vim.opt.shiftwidth = 4 -- Size of an indent
    vim.opt.smartindent = true -- Insert indents automatically
    vim.opt.softtabstop = 4 -- Number of spaces tabs count for **
    vim.opt.tabstop = 4 -- Number of spaces in a tab

    -------------------- WINDOW OPTIONS --------------------
    -- vim.wo.colorcolumn = "80,120,160" -- Make a ruler at 80px and 120px
    vim.opt.colorcolumn = "80,120,160" -- Make a ruler at 80px and 120px
    vim.opt.list = true -- Show some invisible characters like tabs etc
    vim.opt.listchars = 'tab:›■,trail:•,extends:#,nbsp:.'
    -- vim.wo.numberwidth = 2 -- Make the line number column thinner
    ---Note: Setting number and relative number gives you hybrid mode
    ---https://jeffkreeftmeijer.com/vim-number/
    vim.opt.number = true -- Set the absolute number
    vim.opt.relativenumber = true -- Set the relative number
    vim.opt.signcolumn = "yes:1" -- Show information next to the line numbers

    -- wrap
    vim.opt.wrap = true -- Do not display text over multiple lines
    vim.opt.wrapmargin = 1
    vim.opt.breakindent = true
    vim.opt.breakindentopt = "shift:2,sbr" -- lin wrap opts
    vim.opt.linebreak = true
    -- vim.wo.breakat = ""
    vim.opt.whichwrap:append 'b,s,h,l,<,>,[,]'

    -------------------- VIM OPTIONS --------------------
    vim.o.background = "dark"
    vim.opt.belloff = { 'esc', 'spell' }
    vim.opt.cmdheight = 2 -- Hide the command bar
    vim.opt.clipboard = { "unnamedplus" } -- Use the system clipboard
    vim.opt.completeopt = { "menuone", "noselect" } -- Completion opions for code completion
    vim.opt.cursorline = true
    vim.opt.cursorcolumn = true
    vim.opt.cursorlineopt = "screenline,number" -- Highlight the screen line of the cursor with CursorLine and the line number with CursorLineNr **
    vim.opt.emoji = false -- Turn off emojis **
    vim.opt.fillchars = {
        horiz = "━",
        horizup = "┻",
        horizdown = "┳",
        vert = "┃",
        vertleft = "┫",
        vertright = "┣",
        verthoriz = "╋",
        fold = "-",
        -- stl = " ",
    }
    vim.opt.foldenable = true -- Enable folding
    vim.opt.foldlevel = 0 -- Fold by default
    -- vim.opt.foldmethod = "marker" -- Fold based on markers as opposed to indentation
    vim.opt.foldmethod = "manual" -- folding, set to "expr" for treesitter based folding
    vim.opt.foldexpr = "" -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
    vim.opt.laststatus = 3 -- Use global statusline **
    vim.opt.modelines = 1 -- Only use folding settings for this file
    vim.opt.mouse = "a" -- Use the mouse in all modes
    vim.opt.mousemoveevent = true -- for bufferline hover
    vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize" -- Session options to store in the session
    vim.opt.scrolljump = 1
    vim.opt.scrolloff = 6 -- Set the cursor 5 lines down instead of directly at the top of the file
    --[[
        NOTE: don't store marks as they are currently broken in Neovim!
        @credit: wincent
    ]]
    vim.opt.shada = "!,'0,f0,<50,s10,h" -- **
    vim.opt.shiftround = true -- Round indent **
    vim.opt.shortmess:append 'fxtOrmnlTwoi'
    -- vim.opt.shortmess = {
    --     A = true, -- ignore annoying swap file messages
    --     c = true, -- Do not show completion messages in command line
    --     F = true, -- Do not show file info when editing a file, in the command line
    --     I = true, -- Do not show the intro message
    --     W = true, -- Do not show "written" in command line when writing
    -- }
    vim.opt.showcmd = true -- Do not show me what I'm typing

    -- search
    vim.opt.showmatch = true -- Show matching brackets by flickering
    vim.opt.incsearch = true
    vim.opt.hlsearch = true
    vim.opt.smartcase = true -- Don't ignore case with capitals
    vim.opt.ignorecase = true -- Ignore case
    vim.opt.iskeyword:remove({ '.', '#', '-' })

    vim.opt.showmode = true -- Do not show the mode
    vim.opt.sidescrolloff = 8 -- The minimal number of columns to keep to the left and to the right of the cursor if 'nowrap' is set **
    vim.opt.splitbelow = true -- Put new windows below current
    vim.opt.splitright = true -- Put new windows right of current
    vim.o.termguicolors = true -- True color support
    vim.opt.textwidth = 120 -- Total allowed width on the screen
    vim.opt.timeout = true -- This option and 'timeoutlen' determine the behavior when part of a mapped key sequence has been received. This is on by default but being explicit! **
    vim.opt.timeoutlen = 500 -- Time in milliseconds to wait for a mapped sequence to complete. **
    vim.opt.ttimeoutlen = 10 -- Time in milliseconds to wait for a key code sequence to complete **
    vim.opt.updatetime = 100 -- If in this many milliseconds nothing is typed, the swap file will be written to disk. Also used for CursorHold autocommand and set to 100 as per https://github.com/antoinemadec/FixCursorHold.nvim **
    vim.opt.wildmenu = true
    vim.opt.wildmode = "list:longest,full" -- Command-line completion mode
    vim.opt.wildignore = { "*/.git/*", "*/node_modules/*" } -- Ignore these files/folders **
    vim.opt.virtualedit = 'onemore'

    -- Create folders for our backups, undos, swaps and sessions if they don't exist
    vim.cmd("silent call mkdir(stdpath('data').'/backups', 'p', '0700')")
    vim.cmd("silent call mkdir(stdpath('data').'/undos', 'p', '0700')")
    vim.cmd("silent call mkdir(stdpath('data').'/swaps', 'p', '0700')")
    vim.cmd("silent call mkdir(stdpath('data').'/sessions', 'p', '0700')")

    vim.opt.backupdir = vim.fn.stdpath("data") .. "/backups" -- Use backup files
    vim.opt.directory = vim.fn.stdpath("data") .. "/swaps" -- Use Swap files
    vim.opt.undofile = true -- Maintain undo history between sessions
    vim.opt.undolevels = 1000 -- Ensure we can undo a lot! **
    vim.opt.undodir = vim.fn.stdpath("data") .. "/undos" -- Set the undo directory

    -- vim.opt.backup = false,
    --[[if a file is being edited by another program
    (or was written to file while editing with another program), it is not allowed to be edited ]]
    -- vim.opt.writebackup = false,
    vim.opt.swapfile = false -- don't use a swap file

    --------------------------------------------------------

    -- vim.opt.shortmess:append 'fxtOrmnlTwoi'

    -- syntax on 会引起site/after/ftplugin中的文件加载两次, 造成启动两次lsp, 不要启用
    -- vim.cmd('syntax on')
    -- vim.cmd('syntax enable')
    -- vim.cmd("colorscheme xxx")


    for k, v in pairs(default_options) do
        -- print(k, v)
        vim.opt[k] = v
    end


    if vim.loop.os_uname().version:match "Windows" then
        vim.g.sqlite_clib_path = join_paths(get_config_dir(), "sqlite3", "sqlite3.dll")
    end

end

function M.load_headless_options()
    vim.opt.shortmess = "" -- try to prevent echom from cutting messages off or prompting
    vim.opt.more = false -- don't pause listing when screen is filled
    vim.opt.cmdheight = 9999 -- helps avoiding |hit-enter| prompts.
    vim.opt.columns = 9999 -- set the widest screen possible
    vim.opt.swapfile = false -- don't use a swap file
end

function M.load_defaults()
    if #vim.api.nvim_list_uis() == 0 then
        M.load_headless_options()
        return
    end
    M.load_default_options()
end

return M
