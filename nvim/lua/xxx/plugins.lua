local plugins = {
    { 'wbthomason/packer.nvim' },

    -- Log --
    {
        "rcarriga/nvim-notify",
        config = function()
            require("xxx.plugin-config.notify").setup()
        end,
    },
    { "Tastyep/structlog.nvim" },

    {
        -- theme
        {
            "olimorris/onedarkpro.nvim",
            as = "colorscheme",
            config = function()
                require('xxx.plugin-config.colorscheme.onedarkpro').setup()
            end,
        },
        {
            'navarasu/onedark.nvim',
            -- as = "colorscheme",
            -- config = function()
            --     require('xxx.plugin-config.colorscheme.onedark').setup()
            -- end,
        },
        {
            -- SchemaStore
            "b0o/schemastore.nvim",
        },
    },

    {
        "folke/which-key.nvim",
        config = function()
            require("xxx.plugin-config.which-key").setup()
        end,
        event = "BufWinEnter",
    },
    {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        config = function()
            require("xxx.plugin-config.hop").setup()
        end
    },

    {
        -- Highlight hex and rgb colors within Neovim
        -- "norcalli/nvim-colorizer.lua",
        'NvChad/nvim-colorizer.lua',
        config = function()
            require('xxx.plugin-config.colorizer').setup()
        end,
    },

    {
        "petertriho/nvim-scrollbar", -- A scrollbar for the current window
        after = "colorscheme",
        requires = {
            {
                "kevinhwang91/nvim-hlslens", -- Highlight searches
                config = function()
                    require("xxx.plugin-config.scroll.hlslens").setup()
                end,
            },
            {
                "declancm/cinnamon.nvim", -- Smooth scrolling
                config = function()
                    require("xxx.plugin-config.scroll.cinnamon").setup()
                end,
            },
        },
        config = function()
            require("xxx.plugin-config.scroll.scrollbar").setup()
        end,
    },

    {
        "tpope/vim-sleuth", -- Automatically detects which indents should be used in the current buffer
    },

    {
        "kylechui/nvim-surround",
        config = function()
            require("xxx.plugin-config.surround").setup()
        end,
    },

    -- { "nvim-lua/popup.nvim", opt = true },
    { "nvim-lua/plenary.nvim", module = "plenary" },
    {
        -- 列表模糊搜索框架, 高扩展
        -- need install BurntSushi/ripgrep
        -- :Telescope find_files<cr>
        "nvim-telescope/telescope.nvim",
        after = "colorscheme",
        branch = "0.1.x",
        requires = {
            'nvim-lua/plenary.nvim',
            -- {
            --     "nvim-telescope/telescope-project.nvim", -- Switch between projects
            --     after = "telescope.nvim",
            --     config = function()
            --         require("telescope").load_extension("project")
            --     end,
            -- },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                after = "telescope.nvim",
                requires = { "nvim-telescope/telescope.nvim" },
                config = function()
                    require("telescope").load_extension("fzf")
                end,
                run = "make",
            },
            {
                "nvim-telescope/telescope-frecency.nvim", -- Get frequently opened files
                after = "telescope.nvim",
                requires = {
                    { "tami5/sqlite.lua" },
                },
                config = function()
                    require("telescope").load_extension("frecency")
                end,
            },
            {
                "nvim-telescope/telescope-smart-history.nvim", -- Show project dependant history
                after = "telescope.nvim",
                requires = {
                    { "tami5/sqlite.lua" },
                },
                config = function()
                    require("telescope").load_extension("smart_history")
                end,
            },
        },
        config = function()
            require("xxx.plugin-config.telescope").setup()
        end,
    },
    -- { 'nvim-telescope/telescope-ui-select.nvim' },
    {
        -- vim.ui.select, vim.ui.input hooks
        'stevearc/dressing.nvim',
        after = "telescope.nvim",
        config = function()
            require("xxx.plugin-config.dressing").setup()
        end,
    },

    { 'kyazdani42/nvim-web-devicons', },
    {
        -- bufferline color and show work: load order colorscheme->bufferline->alpha-nvim
        'akinsho/bufferline.nvim',
        -- tag = "v2.*",
        branch = "main",
        after = "colorscheme",
        -- event = "BufWinEnter",
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function()
            require('xxx.plugin-config.bufferline').setup()
        end,
    },

    {
        "famiu/bufdelete.nvim", -- Easily close buffers whilst preserving your window layouts
        cmd = { "Bdelete", "Bwipeout" },
    },

    {
        'nvim-lualine/lualine.nvim',
        after = "colorscheme",
        requires = { 'kyazdani42/nvim-web-devicons' },
        -- config = function()
        --     require("xxx.plugin-config.statusline.lualine").setup()
        -- end,
    },
    {
        "feline-nvim/feline.nvim", -- Statusline
        after = "colorscheme",
        requires = {
            { "kyazdani42/nvim-web-devicons" }, -- Web icons for various plugins
        },
        config = function()
            require("xxx.plugin-config.statusline.feline").setup()
        end,
    },

    {
        -- NvimTree
        "kyazdani42/nvim-tree.lua",
        -- event = "BufWinOpen",
        -- cmd = "NvimTreeToggle",
        after = "colorscheme",
        requires = {
            'nvim-telescope/telescope.nvim',
            { 'kyazdani42/nvim-web-devicons', opt = true, }
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

    -- alpha
    {

        "goolord/alpha-nvim",
        after = "bufferline.nvim",
        config = function()
            require("xxx.plugin-config.alpha").setup()
        end,
    },
    {
        "Shatur/neovim-session-manager",
        config = function()
            require("xxx.plugin-config.session.session-manager").setup()
        end,
    },
    -- {
    -- session-manager has bugs in windows
    -- "olimorris/persisted.nvim",
    -- config = function()
    --     require("xxx.plugin-config.session.persisted").setup()
    -- end,
    -- },
    {
        "ahmedkhalf/project.nvim",
        after = "telescope.nvim",
        config = function()
            require("xxx.plugin-config.project").setup()
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
        -- install and manager LSP, DAP, linters, formatters
        {
            "williamboman/mason.nvim",
            config = function()
                require("xxx.plugin-config.mason").setup()
            end,
        },
        {
            "williamboman/mason-lspconfig.nvim",
            requires = {
                { "neovim/nvim-lspconfig" },

            },
        },
        {
            -- null-ls是一个将非LSP的包与nvim内置LSP客户端整合的插件
            "jose-elias-alvarez/null-ls.nvim",
        },
        -- {
        --     -- A plugin to configure Neovim LSP using json/yaml
        --     "tamago324/nlsp-settings.nvim",
        --     -- disable = true,
        -- },
        {
            -- Standalone UI for nvim-lsp progress.
            "j-hui/fidget.nvim",
            config = function()
                require("xxx.plugin-config.fidget").setup()
            end,
        },
        {
            'folke/lsp-colors.nvim',
            config = function()
                require("xxx.plugin-config.lsp-colors").setup()
            end,
        },
        {
            -- breadcrumbs
            -- 不提供显示功能, 需要其他插件显示
            'SmiteshP/nvim-navic',
            requires = { "neovim/nvim-lspconfig" },
            config = function()
                require("xxx.plugin-config.breadcrumbs").setup()
            end,
        },
        {
            "folke/trouble.nvim",
            requires = { "kyazdani42/nvim-web-devicons", opt = true },
            config = function()
                require("xxx.plugin-config.trouble").setup()
            end,
        },
        {
            -- has breadcrumbs
            "glepnir/lspsaga.nvim",
            after = "colorscheme",
            branch = "main",
            config = function()
                require("xxx.plugin-config.lspsaga").setup()
            end,
        },
    },

    {
        -- Install nvim-cmp, and buffer source as a dependency
        {
            "hrsh7th/nvim-cmp",
            requires = {
                {
                    -- Code snippets
                    "L3MON4D3/LuaSnip",
                    requires = {
                        "rafamadriz/friendly-snippets",
                    },
                    config = function()
                        require("xxx.plugin-config.luasnip").setup()
                    end,
                },
                -- cmp sources --
                { "hrsh7th/cmp-nvim-lsp" },
                { "hrsh7th/cmp-nvim-lua" },
                { "hrsh7th/cmp-buffer" },
                { "hrsh7th/cmp-path" },
                { "saadparwaiz1/cmp_luasnip" },

            },
            config = function()
                require("xxx.plugin-config.cmp").setup()
            end,
        },
        -- {
        --     -- vim functions for dev
        --     "folke/lua-dev.nvim",
        --     module = "lua-dev",
        -- },
        {
            -- vim functions for dev
            "folke/neodev.nvim",
            module = "neodev",
        },
    },

    -- Comments
    {
        "numToStr/Comment.nvim",
        event = "BufRead",
        config = function()
            require("xxx.plugin-config.comment").setup()
        end,
    },

    -- Treesitter
    {
        -- highlight, linter, formater, indent framework
        "nvim-treesitter/nvim-treesitter",
        -- run = ":TSUpdate",
        requires = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects", -- Syntax aware text-objects, select, move, swap, and peek support.
            },
            {
                "windwp/nvim-autopairs",
                -- event = "InsertEnter",
                config = function()
                    require("xxx.plugin-config.autopairs").setup()
                end,
            },
            {
                "p00f/nvim-ts-rainbow",
            },
            {
                "lukas-reineke/indent-blankline.nvim",
                config = function()
                    require("xxx.plugin-config.indent-blankline").setup()
                end,
            },
            {
                -- 高亮显示相同的单词
                "RRethy/vim-illuminate",
                config = function()
                    require("xxx.plugin-config.illuminate").setup()
                end,
            },
            {
                -- tsx 注释增强
                "JoosepAlviste/nvim-ts-context-commentstring",
                event = "BufReadPost",
            },
        },
        config = function()
            require("xxx.plugin-config.treesitter").setup()
        end,
    },
    {
        -- 代码吸顶
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            require('xxx.plugin-config.treesitter-context').setup()
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

}
return plugins
