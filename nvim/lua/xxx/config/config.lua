Xvim = {
    colorscheme = 'onedarkpro',
    log = {
        ---@usage can be { "trace", "debug", "info", "warn", "error", "fatal" },
        level = 'info',
        viewer = {
            ---@usage this will fallback on "less +F" if not found
            cmd = 'lnav',
            layout_config = {
                ---@usage direction = 'vertical' | 'horizontal' | 'window' | 'float',
                direction = 'horizontal',
                open_mapping = '',
                size = 40,
                float_opts = {},
            },
        },
        -- currently disabled due to instabilities
        override_notify = false,
    },
}
