local M = {}
local default_options = {
    backup = false,
    --[[if a file is being edited by another program
    (or was written to file while editing with another program), it is not allowed to be edited ]]
    writebackup = false,
    swapfile = false,
    undofile = true,

    -- 去除蜂鸣
    belloff = { 'esc', 'spell' },
    compatible = false,
    clipboard = "unnamedplus",
    virtualedit = 'onemore',
    -- required to keep multiple buffers and open multiple buffers
    -- Allow buffer switching without saving
    hidden = true,
    linebreak = true,
    tabpagemax = 15,
    showmode = true,
    showcmd = true,
    cmdheight = 2,

    textwidth = 80,
    cursorline = true,
    cursorcolumn = true,
    colorcolumn = "+1",
    number = true,
    relativenumber = true,
    -- number column width
    -- numberwidth = 4,
    --- always show the sign column, otherwise it would shift the text each time
    -- signcolumn = "yes",
    guifont = "monospace:h13",

    wrap = true,
    wrapmargin = 1,
    breakindent = true,
    breakindentopt = "shift:2,sbr",

    mouse = "a",
    -- 窗口分隔线和fold线
    fillchars = 'vert:|,fold:-',
    linespace = 0,

    -- search
    showmatch = true,
    incsearch = true,
    hlsearch = true,
    ignorecase = true,
    smartcase = true,

    -- pop list
    -- show list instead of just completing
    wildmenu = true,
    wildmode = "list:longest,full",

    foldenable = true,
    scrolljump = 1,
    scrolloff = 3,

    list = true,
    listchars = 'tab:›■,trail:•,extends:#,nbsp:.',

    autoindent = true,
    -- the number of spaces inserted for each identation
    shiftwidth = 4,
    -- convert tabs to spaces
    expandtab = true,
    -- insert x spaces for a tab
    tabstop = 4,
    softtabstop = 4,

    -- puts new vsplit windows to the right of the current
    splitright = true,
    -- put new split windows to the bottom of the current
    splitbelow = true,

    completeopt = { "menuone", "noselect" },

    -- bufferline need
    termguicolors = true,

    background = 'dark',

    -- treesitter
    foldmethod = "manual", -- folding, set to "expr" for treesitter based folding
    foldexpr = "" -- set to "nvim_treesitter#foldexpr()" for treesitter based folding

}

M.load_default_options = function()
    -- vim.opt.colorcolumn =  vim.opt.colorcolumn+1

    vim.opt.shortmess:append 'filmnrwxoOtT'
    vim.opt.whichwrap:append 'b,s,h,l,<,>,[,]'
    vim.opt.iskeyword:remove({ '.', '#', '-' })

    -- syntax on 会引起site/after/ftplugin中的文件加载两次, 造成启动两次lsp, 不要启用
    -- vim.cmd('syntax on')
    -- vim.cmd('syntax enable')
    -- vim.cmd("colorscheme xxx")

    vim.g.mapleader = ","
    vim.g.maplocalleader = "_"


    for k, v in pairs(default_options) do
        -- print(k, v)
        vim.opt[k] = v
    end

end

M.load_headless_options = function()
    vim.opt.shortmess = "" -- try to prevent echom from cutting messages off or prompting
    vim.opt.more = false -- don't pause listing when screen is filled
    vim.opt.cmdheight = 9999 -- helps avoiding |hit-enter| prompts.
    vim.opt.columns = 9999 -- set the widest screen possible
    vim.opt.swapfile = false -- don't use a swap file
end

M.load_defaults = function()
    if #vim.api.nvim_list_uis() == 0 then
        M.load_headless_options()
        return
    end
    M.load_default_options()
end

return M
