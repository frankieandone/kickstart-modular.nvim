-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

    require 'plugins.nvim-web-devicons',
    require 'plugins.nvim-tree',
    require 'plugins.treesitter',
    require 'plugins.telescope',
    require 'plugins.gitsigns',

    require 'plugins.lspconfig',
    require 'plugins.conform',
    require 'plugins.cmp',
    require 'plugins.trouble',
    require 'plugins.null-ls',
    require 'plugins.lint',

    require 'plugins.mini',

    require 'plugins.autopairs',
    require 'plugins.indent_line',
    require 'plugins.grug-far',
    require 'plugins.todo-comments',
    require 'plugins.nvim-colorizer',

    require 'plugins.which-key',
    require 'plugins.debug',
}, {
    ui = {
        icons = vim.g.have_nerd_font or {},
    },
})

-- vim: ts=2 sts=2 sw=2 et
