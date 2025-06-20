return {
    {
        'NeogitOrg/neogit',
        version = 'v0.0.1', -- Pin to version compatible with Neovim 0.9.x
        dependencies = {
            'nvim-lua/plenary.nvim', -- required
            'sindrets/diffview.nvim', -- optional - Diff integration

            -- Only one of these is needed, not both.
            'nvim-telescope/telescope.nvim', -- optional
            -- 'ibhagwan/fzf-lua', -- optional
        },
        config = function()
            require('neogit').setup {
                integrations = {
                    telescope = true,
                    diffview = true,
                },
            }
            vim.keymap.set(
                'n',
                '<leader>sgf',
                ':Neogit<CR>',
                { desc = '[S]earch [g]it [f]iles', noremap = true, silent = true }
            )
        end,
    },
}
