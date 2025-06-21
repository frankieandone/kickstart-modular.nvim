return {
    {
        'nvim-tree/nvim-web-devicons',
        version = '*',
        lazy = false,
        config = function()
            require('nvim-web-devicons').setup {
                color_icons = false,
                default = true,
                strict = true,
            }
        end,
    },
}
