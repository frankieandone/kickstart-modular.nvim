return {
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup({
                '*', -- Apply to all filetypes
                css = { rgb_fn = true }, -- Enable RGB functions in CSS
            }, {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = true, -- "Name" codes like Blue
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = true, -- Enable all CSS features
                css_fn = true, -- Enable all CSS *functions*
                mode = 'background', -- Set the display mode
            })
        end,
    },
}
