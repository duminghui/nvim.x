local plugins = {
    { 'wbthomason/packer.nvim' },

    -- theme
    {
        'NvChad/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end
    },
    {
        'navarasu/onedark.nvim',
        config = function()
            require('xxx.plugin-config.onedark').setup()
        end,
    },

    -- install and manager LSP, DAP, linters, formatters
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    {
        "williamboman/mason.nvim",
        config = function()
            require("xxx.plugin-config.mason").setup()
        end
    },
    {
        -- null-ls是一个将非LSP的包与nvim内置LSP客户端整合的插件
        "jose-elias-alvarez/null-ls.nvim",
    },
    {
        -- A plugin to configure Neovim LSP using json/yaml
        "tamago324/nlsp-settings.nvim",
    },


    -- Log --
    {
        "rcarriga/nvim-notify",
        config = function()
            require("xxx.plugin-config.notify").setup()
        end,
        requires = { "nvim-telescope/telescope.nvim" },
    },
    { "Tastyep/structlog.nvim" },

    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("xxx.plugin-config.telescope").setup()
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        requires = { "nvim-telescope/telescope.nvim" },
        run = "make",
    },

    -- Install nvim-cmp, and buffer source as a dependency
    {
        "hrsh7th/nvim-cmp",
        config = function()
            require("xxx.plugin-config.cmp").setup()
        end,
        requires = {
            "L3MON4D3/LuaSnip",
        },
    },
    {
        "rafamadriz/friendly-snippets",
    },
    {
        "L3MON4D3/LuaSnip",
        config = function()
            local utils = require "xxx.utils"
            local paths = {}
            paths[#paths + 1] = utils.join_paths(get_runtime_dir(), "site", "pack", "packer", "start",
                "friendly-snippets")
            local user_snippets = utils.join_paths(get_config_dir(), "snippets")
            if utils.is_directory(user_snippets) then
                paths[#paths + 1] = user_snippets
            end
            require("luasnip.loaders.from_lua").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load {
                paths = paths,
            }
            require("luasnip.loaders.from_snipmate").lazy_load()
        end,
        requires = {
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "saadparwaiz1/cmp_luasnip",
    },
    {
        "hrsh7th/cmp-buffer",
    },
    {
        "hrsh7th/cmp-path",
    },
    {
        "folke/lua-dev.nvim",
        module = "lua-dev",
    },


    {
        -- 导航路径: breadcrumbs
        'SmiteshP/nvim-navic',
    },

    {
        'akinsho/bufferline.nvim',
        tag = "v2.*",
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('xxx.plugin-config.bufferline').setup()
        end,
    },



    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require("xxx.plugin-config.lualine").setup()
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("xxx.plugin-config.gitsigns").setup()
        end,
        event = "BufRead",
    },

    -- Treesitter
    {
        -- highlight, linter, formater, indent
        "nvim-treesitter/nvim-treesitter",
        -- run = ":TSUpdate",
        config = function()
            require("xxx.plugin-config.treesitter").setup()
        end,
    },
    {
        -- 代码吸顶
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require('treesitter-context').setup()
        end,
    },
    {
        -- tsx 注释增强
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = "BufReadPost",
        config = function()
            require("xxx.plugin-config.ts-context-commentstring").setup()
        end,
    },

    {
        "p00f/nvim-ts-rainbow",
        config = function()
            require("xxx.plugin-config.rainbow").setup()
        end,
    },

    -- indent
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("xxx.plugin-config.indent-blankline").setup()
        end,
    },

    -- SchemaStore
    {
        "b0o/schemastore.nvim",
    },

    {
        "RRethy/vim-illuminate",
        config = function()
            require("xxx.plugin-config.illuminate").setup()
        end,
    },


    -- Autopairs
    {
        "windwp/nvim-autopairs",
        -- event = "InsertEnter",
        config = function()
            require("xxx.plugin-config.autopairs").setup()
        end,
    },

    -- Comments
    {
        "numToStr/Comment.nvim",
        event = "BufRead",
        config = function()
            require("xxx.plugin-config.comment").setup()
        end,
    },
    --

}
return plugins
