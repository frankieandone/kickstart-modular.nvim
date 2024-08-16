-- Highlight todo, notes, etc in comments
return {
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = { 'TodoTrouble', 'TodoTelescope' },
        opts = {
            signs = false,
        },
        keys = {
            {
                ']t',
                function()
                    require('todo-comments').jump_next()
                end,
                desc = 'Next Todo Comment',
            },
            {
                '[t',
                function()
                    require('todo-comments').jump_prev()
                end,
                desc = 'Previous Todo Comment',
            },
            { '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'Todo (Trouble)' },
            {
                '<leader>xT',
                '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>',
                desc = 'Todo/Fix/Fixme (Trouble)',
            },
            { '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Todo' },
            { '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', desc = 'Todo/Fix/Fixme' },
        },
    },
}
-- vim: ts=2 sts=2 sw=2 et
