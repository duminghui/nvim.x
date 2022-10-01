return function()
    -- Eviline config for lualine
    -- Author: shadmansaleh
    -- Credit: glepnir
    local lualine = require 'lualine'

    -- Color table for highlights
    -- stylua: ignore
    local colors = {
        bg = '#202328',
        fg = '#bbc2cf',
        yellow = '#FFD700',
        -- yellow   = '#ECBE7B',
        cyan = '#008080',
        darkblue = '#081633',
        green = '#98be65',
        -- orange   = '#FF8800',
        orange = '#FFA500',
        violet = '#a9a1e1',
        magenta = '#c678dd',
        blue = '#51afef',
        -- red      = '#ec5f67',
        red = '#E3170D'
    }

    local conditions = {
        buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand '%:t') ~= 1
        end,
        hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
        check_git_workspace = function()
            local filepath = vim.fn.expand '%:p:h'
            local gitdir = vim.fn.finddir('.git', filepath .. ';')
            return gitdir and #gitdir > 0 and #gitdir < #filepath
        end
    }

    local mode_names = {
        ['n'] = 'NORMAL',
        ['no'] = 'O-PENDING',
        ['nov'] = 'O-PENDING',
        ['noV'] = 'O-PENDING',
        ['no'] = 'O-PENDING',
        ['niI'] = 'NORMAL',
        ['niR'] = 'NORMAL',
        ['niV'] = 'NORMAL',
        ['nt'] = 'NORMAL',
        ['v'] = 'VISUAL',
        ['vs'] = 'VISUAL',
        ['V'] = 'V-LINE',
        ['Vs'] = 'V-LINE',
        [''] = 'V-BLOCK',
        ['s'] = 'V-BLOCK',
        ['s'] = 'SELECT',
        ['S'] = 'S-LINE',
        [''] = 'S-BLOCK',
        ['i'] = 'INSERT',
        ['ic'] = 'I-COMP',
        ['ix'] = 'I-COMP',
        ['R'] = 'REPLACE',
        ['Rc'] = 'REPLACE',
        ['Rx'] = 'REPLACE',
        ['Rv'] = 'V-REPLACE',
        ['Rvc'] = 'V-REPLACE',
        ['Rvx'] = 'V-REPLACE',
        ['c'] = 'COMMAND',
        ['cv'] = 'EX-COMMAND',
        ['ce'] = 'EX-NORMAL',
        ['r'] = 'REPLACE',
        ['rm'] = 'MORE',
        ['r?'] = 'CONFIRM',
        ['!'] = 'SHELL',
        ['t'] = 'TERMINAL'
    }

    local get_mode = function() return vim.api.nvim_get_mode()['mode'] end

    local vi_mode = function()
        local mode = get_mode()
        local alias = mode_names[mode]
        if not alias then return '' end
        return alias
    end

    -- Config
    local config = {
        options = {
            -- Disable sections and component separators
            component_separators = '',
            section_separators = '',
            theme = {
                -- We are going to use lualine_c an lualine_x as left and
                -- right section. Both are highlighted by c theme .  So we
                -- are just setting default looks o statusline
                normal = { c = { fg = colors.fg, bg = colors.bg } },
                inactive = { c = { fg = colors.fg, bg = colors.bg } }
            }
        },
        sections = {
            -- these are to remove the defaults
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
            -- These will be filled later
        },
        inactive_sections = {
            -- these are to remove the defaults
            lualine_a = {},
            lualine_v = {},
            lualine_y = {},
            lualine_z = {},
            lualine_c = {},
            lualine_x = {}
        }
    }

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x ot right section
    local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
    end

    -- Inserts a component in lualine_c at left section
    local function ins_inactive_left(component)
        table.insert(config.inactive_sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x ot right section
    local function ins_inactive_right(component)
        table.insert(config.inactive_sections.lualine_x, component)
    end

    ins_left {
        function() return '▊' end,
        color = { fg = colors.blue }, -- Sets highlighting of component
        padding = { left = 0, right = 1 } -- We don't need space before this
    }

    ins_left {
        -- mode component
        function()
            -- auto change color according to neovims mode
            local mode_color = {
                n = colors.violet,
                no = colors.red,
                nov = colors.red,
                noV = colors.red,
                ['no'] = colors.red,
                niI = colors.violet,
                niR = colors.violet,
                niV = colors.violet,
                nt = colors.violet,
                v = colors.blue,
                vs = colors.blue,
                V = colors.blue,
                Vs = colors.blue,
                [''] = colors.blue,
                ['s'] = colors.blue,
                s = colors.orange,
                S = colors.orange,
                [''] = colors.orange,
                i = colors.green,
                ic = colors.green,
                ix = colors.green,
                R = colors.violet,
                Rc = colors.violet,
                Rx = colors.violet,
                Rv = colors.violet,
                Rvc = colors.violet,
                Rvx = colors.violet,
                c = colors.magenta,
                cv = colors.magenta,
                ce = colors.violet,
                r = colors.cyan,
                rm = colors.cyan,
                ['r?'] = colors.cyan,
                ['!'] = colors.red,
                t = colors.red
            }
            vim.api.nvim_command('hi! LualineMode gui=bold guifg=' ..
                mode_color[vim.fn.mode()] .. ' guibg=' ..
                colors.bg)
            -- return ''
            return vi_mode()
        end,
        color = 'LualineMode',
        padding = { right = 1 }
    }

    ins_left {
        -- filesize component
        'filesize',
        cond = conditions.buffer_not_empty
    }

    ins_left {
        'filename',
        cond = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = 'bold' }
    }

    ins_left {
        'branch',
        icon = '',
        color = { fg = colors.violet, gui = 'bold' }
    }

    ins_left {
        'diff',
        -- Is it me or the symbol for modified us really weird
        symbols = { added = ' ', modified = '柳 ', removed = ' ' },
        diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.orange },
            removed = { fg = colors.red }
        },
        cond = conditions.hide_in_width
    }

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    ins_left { function() return '%=' end }

    ins_right {
        -- Lsp server name .
        function()
            local msg = 'No Active Lsp'
            local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then return msg end
            local clientnames = ''
            for _, client in ipairs(clients) do
                -- local filetypes = client.config.filetypes
                if client.attached_buffers[vim.fn.bufnr()] ~= nil then
                    clientnames = clientnames .. client.name .. ' '
                end
            end
            if string.len(clientnames) > 0 then
                return string.sub(clientnames, 1, string.len(clientnames) - 1)
            end
            return msg
        end,
        icon = ' LSP:',
        color = { fg = colors.cyan, gui = 'bold' }
    }

    ins_right {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
        diagnostics_color = {
            color_error = { fg = colors.red },
            color_warn = { fg = colors.yellow },
            color_info = { fg = colors.cyan }
        }
    }

    -- Add components to right sections
    ins_right {
        'o:encoding', -- option component same as &encoding in viml
        fmt = string.upper, -- I'm not sure why it's upper case either ;)
        cond = conditions.hide_in_width,
        color = { fg = colors.green, gui = 'bold' }
    }

    ins_right {
        'fileformat',
        fmt = string.upper,
        icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
        color = { fg = colors.green, gui = 'bold' }
    }

    ins_right { 'location' }

    ins_right { 'progress', color = { fg = colors.fg, gui = 'bold' } }

    ins_right {
        function() return '▊' end,
        color = { fg = colors.blue },
        padding = { left = 1, right = 0 }
    }

    ----------------
    -- inactive line
    ----------------

    ins_inactive_left {
        'filename',
        cond = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = 'bold' }
    }

    ins_inactive_right { 'location' }

    -- ins_inactive_right {'progress', color = {fg = colors.fg, gui = 'bold'}}

    -- Now don't forget to initialize lualine
    lualine.setup(config)
end
