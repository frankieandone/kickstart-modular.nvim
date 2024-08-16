return {
    {
        'jose-elias-alvarez/null-ls.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local null_ls = require 'null-ls'
            local sources = {
                null_ls.builtins.formatting.prettierd.with {
                    condition = function(utils)
                        return utils.root_has_file '.editorconfig' or utils.root_has_file '.eslintrc.js'
                    end,
                },
            }
            null_ls.setup { sources = sources }
        end,
    },
}
