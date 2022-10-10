local M = {}

-- local colors = require("xxx.core.colors")

M.opts = {
    onedarkpro = {
        dark_theme = "onedark_vivid", -- The default dark theme
        light_theme = "onelight", -- The default light theme
        caching = false, -- Use caching for the theme?
        cache_path = vim.fn.expand(vim.fn.stdpath("cache") .. "/onedarkpro/"), -- The path to the cache directory
        colors = {
            onedark_vivid = {
                vim = "#81b766", -- green
                brackets = "#abb2bf", -- fg / gray
                cursorline = "#2e323b",
                indentline = "#3c414d",

                ghost_text = "#555961",

                bufferline_text_focus = "#949aa2",

                statusline_bg = "#2e323b", -- gray

                telescope_prompt = "#2e323a",
                telescope_results = "#21252d",
            },
        }, -- Override default colors by specifying colors for 'onelight' or 'onedark' themes
        highlights = {
            CursorLineNr = { fg = "#FFD700" },
            CursorColumn = { link = "CursorLine" },
        }, -- Override default highlight and/or filetype groups
        filetypes = { -- Override which filetype highlight groups are loaded
            markdown = true,
            python = true,
            ruby = true,
            yaml = true,
        },
        plugins = { -- Override which plugin highlight groups are loaded
            -- See the Supported Plugins section for a list of available plugins
        },
        styles = { -- Choose from "bold,italic,underline"
            strings = "NONE", -- Style that is applied to strings.
            comments = "NONE", -- Style that is applied to comments
            keywords = "NONE", -- Style that is applied to keywords
            functions = "NONE", -- Style that is applied to functions
            variables = "NONE", -- Style that is applied to variables
            virtual_text = "NONE", -- Style that is applied to virtual text
        },
        options = {
            bold = false, -- Use the colorscheme's opinionated bold styles?
            italic = false, -- Use the colorscheme's opinionated italic styles?
            underline = false, -- Use the colorscheme's opinionated underline styles?
            undercurl = false, -- Use the colorscheme's opinionated undercurl styles?
            cursorline = true, -- Use cursorline highlighting?
            transparency = false, -- Use a transparent background?
            terminal_colors = false, -- Use the colorscheme's colors for Neovim's :terminal?
            window_unfocused_color = false, -- When the window is out of focus, change the normal background?
        }
    },
    onedark = {
        style = 'darker',
        lualine = {
            transparent = false,
        },
        highlights = {
            CursorLineNr = { fg = "#FFD700" },
        },
    }

}

M.setup = function()

    if xvim.colorscheme == "onedarkpro" then
        local status_ok, onedarkpro = pcall(require, "onedarkpro")
        if not status_ok then
            return
        end
        onedarkpro.setup(M.opts.onedarkpro)
        vim.g.colors_name = xvim.colorscheme
        vim.api.nvim_command('colorscheme ' .. xvim.colorscheme)
    elseif xvim.colorscheme == "onedark" then
        local status_ok, onedark = pcall(require, "onedark")
        if not status_ok then
            return
        end
        onedark.setup(M.opts.onedark)
        onedark.load()
    else
        return
    end


    -- vim.cmd(string.format("highlight CursorLineNr guifg=%s", "#FFD700"))
    -- 会把整个替换掉
    -- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFE700" })

    -- for lualine
    require("xxx.plugin-config.lualine.components").set_highlight()
    require("xxx.plugin-config.rainbow").set_highlight()
    require("xxx.plugin-config.indent-blankline").set_highlight()
end

return M
