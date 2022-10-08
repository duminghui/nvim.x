local plugins = {
    { 'wbthomason/packer.nvim' },

    -- theme
    {
        'NvChad/nvim-colorizer.lua',
        config = function()
            require('xxx.plugin-config.colorizer').setup()
        end
    },
    {
        'navarasu/onedark.nvim',
        config = function()
            require('xxx.plugin-config.onedark').setup()
        end,
    },

    { 'kyazdani42/nvim-web-devicons', },
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
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
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

    {
        -- NvimTree
        "kyazdani42/nvim-tree.lua",
        -- event = "BufWinOpen",
        -- cmd = "NvimTreeToggle",
        requires = {
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-web-devicons', opt = true,
        },
        config = function()
            require("xxx.plugin-config.nvimtree").setup()
        end,
    },
    {
        -- Lir
        "christianchiarulli/lir.nvim",
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require("xxx.plugin-config.lir").setup()
        end,
        disable = true, -- use NvimTree
    },

    -- { "nvim-lua/popup.nvim", opt = true },
    { "nvim-lua/plenary.nvim" },
    {
        -- 列表模糊搜索框架, 高扩展
        -- need install BurntSushi/ripgrep
        -- :Telescope find_files<cr>
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("xxx.plugin-config.telescope").setup()
        end,
    },
    -- { 'nvim-telescope/telescope-ui-select.nvim' },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        requires = { "nvim-telescope/telescope.nvim" },
        run = "make",
    },

    {
        -- vim.ui.select, vim.ui.input hooks
        'stevearc/dressing.nvim',
        config = function()
            require("xxx.plugin-config.dressing").setup()
        end
    },

    -- Log --
    {
        "rcarriga/nvim-notify",
        config = function()
            require("xxx.plugin-config.notify").setup()
        end,
    },

    { "Tastyep/structlog.nvim" },


    {
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
        { "rafamadriz/friendly-snippets", },
        {
            "L3MON4D3/LuaSnip",
            config = function()
                require("xxx.plugin-config.luasnip").setup()
            end,
            requires = {
                "rafamadriz/friendly-snippets",
            },
        },
        { "hrsh7th/cmp-nvim-lsp", },
        { "saadparwaiz1/cmp_luasnip", },
        { "hrsh7th/cmp-buffer", },
        { "hrsh7th/cmp-path", },
        {
            -- vim functions for dev
            "folke/lua-dev.nvim",
            module = "lua-dev",
        },
    },

    {
        -- install and manager LSP, DAP, linters, formatters
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason-lspconfig.nvim" },
        {
            "williamboman/mason.nvim",
            config = function()
                require("xxx.plugin-config.mason").setup()
            end
        },
        {
            -- Standalone UI for nvim-lsp progress.
            "j-hui/fidget.nvim",
            config = function()
                require("xxx.plugin-config.fidget").setup()
            end
        },
        {
            'folke/lsp-colors.nvim',
            config = function()
                require("xxx.plugin-config.lsp-colors").setup()
            end,
            disable = false,
        },
        {
            -- null-ls是一个将非LSP的包与nvim内置LSP客户端整合的插件
            "jose-elias-alvarez/null-ls.nvim",
        },
        {
            -- A plugin to configure Neovim LSP using json/yaml
            "tamago324/nlsp-settings.nvim",
        },
        -- {
        --     -- breadcrumbs
        --     -- 不提供显示功能, 需要其他插件显示
        --     'SmiteshP/nvim-navic',
        --     requires = { "neovim/nvim-lspconfig" },
        --     config = function()
        --         require("xxx.plugin-config.breadcrumbs").setup()
        --     end
        -- },
        {
            "folke/trouble.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = function()
                require("xxx.plugin-config.trouble").setup()
            end,
        },
        {
            -- has breadcrumbs
            "glepnir/lspsaga.nvim",
            branch = "main",
            config = function()
                require("xxx.plugin-config.lspsaga").setup()
            end,
            disable = false,
        },
    },

    -- Treesitter
    {
        -- highlight, linter, formater, indent framework
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
            require('xxx.plugin-config.treesitter-context').setup()
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
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("xxx.plugin-config.indent-blankline").setup()
        end,
    },

    {
        -- SchemaStore
        "b0o/schemastore.nvim",
    },

    {
        -- 高亮显示相同的字符
        "RRethy/vim-illuminate",
        config = function()
            require("xxx.plugin-config.illuminate").setup()
        end,
        disable = false,
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

    {
        "akinsho/toggleterm.nvim",
        event = "BufWinEnter",
        branch = "main",
        config = function()
            require("xxx.plugin-config.terminal").setup()
        end,
    },

    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("xxx.plugin-config.project").setup()
        end,
    },

    -- alpha
    {
        "goolord/alpha-nvim",
        config = function()
            require("xxx.plugin-config.alpha").setup()
        end,
    },

    {
        "Shatur/neovim-session-manager",
        config = function()
            require("xxx.plugin-config.session-manager").setup()
        end
    },

    {
        "folke/which-key.nvim",
        config = function()
            require("xxx.plugin-config.which-key").setup()
        end,
        event = "BufWinEnter",
    },

}
return plugins
