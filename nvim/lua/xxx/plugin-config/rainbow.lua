local M = {}

local colors = require("xxx.core.colors")

M.opts = {
    treesitter = {
        rainbow = {
            enable = true,
            extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
            max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
            colors = {
                colors.c1,
                colors.c2,
                colors.c3,
                colors.c4,
                colors.c5,
                colors.c6,
                colors.c7,
            },
            -- termcolors = {}
        },
    }
}

M.setup = function()
    require("nvim-treesitter.configs").setup(M.opts.treesitter)
end

M.set_highlight = function()
    for i = 1, 7 do
        local c_key = string.format("c%s", i)
        vim.cmd(string.format("highlight rainbowcol%s guifg=%s", i, colors[c_key]))

    end
end

return M
