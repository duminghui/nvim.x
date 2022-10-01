local M = {}

M.opts = {
    treesitter = {
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
            config = {
                -- Languages that have a single comment style
                typescript = "// %s",
                css = "/* %s */",
                scss = "/* %s */",
                html = "<!-- %s -->",
                svelte = "<!-- %s -->",
                vue = "<!-- %s -->",
                json = "",
            },
        },
    }
}


M.setup = function()
    require("nvim-treesitter.configs").setup(M.opts.treesitter)
end

return M
