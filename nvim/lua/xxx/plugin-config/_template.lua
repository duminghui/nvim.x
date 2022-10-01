local M = {}

M.opts = {

}

M.setup = function()
    --   vim.pretty_print(M.opts)
    require "xxxxx".setup(M.opts)
end

M.set_highlight = function()
    vim.cmd [[highlight xxxxx guifg=#FFD700]]
end

return M
