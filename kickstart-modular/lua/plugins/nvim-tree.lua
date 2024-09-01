return {
    {
        'nvim-tree/nvim-tree.lua',
        version = '*',
        lazy = false,
        dependencies = {
            'nvim-web-devicons', -- not strictly required, but recommended
        },
        config = function()
            require('nvim-tree').setup {
                sort = {
                    sorter = 'case_sensitive',
                },
                view = {
                    width = 30,
                },
                filters = {
                    dotfiles = false,
                },
                renderer = {
                    icons = {
                        glyphs = {
                            default = '', -- File icon
                            symlink = '', -- Symlink icon
                            folder = {
                                arrow_closed = '', -- Arrow when folder is closed
                                arrow_open = '', -- Arrow when folder is open
                                default = '', -- Closed folder
                                open = '', -- Open folder
                                empty = '', -- Empty folder
                                empty_open = '', -- Empty open folder
                                symlink = '', -- Symlink folder
                            },
                            git = {
                                unstaged = '',
                                staged = '',
                                unmerged = '',
                                renamed = '󱀍',
                                untracked = '󰊠',
                                deleted = '',
                                ignored = '',
                            },
                        },
                    },
                },
            }

            vim.api.nvim_create_autocmd('VimEnter', {
                callback = function()
                    -- Check if NvimTree is open and close it if it is
                    local nvim_tree_buf = vim.fn.bufnr 'NvimTree'
                    if nvim_tree_buf ~= -1 then
                        vim.cmd('bdelete ' .. nvim_tree_buf)
                    end
                end,
            })

            function FocusOrToggleNvimTree()
                if vim.api.nvim_eval 'bufname("%")' == 'NvimTree' then
                    if vim.fn['nvim_tree_api'].get_node_at_cursor() then
                        vim.cmd 'NvimTreeToggle' -- already focused
                    else
                        vim.cmd 'NvimTreeFindFile' -- focus file in NvimTree
                    end
                else
                    vim.cmd 'NvimTreeFindFileToggle'
                end
            end

            vim.keymap.set('n', '\\', ':lua FocusOrToggleNvimTree()<CR>', {
                desc = 'Focus if unfocused, otherwise toggle NvimTree',
                nowait = true,
                noremap = true,
                silent = true,
            })
        end,
    },
}
