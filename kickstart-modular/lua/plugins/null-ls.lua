return {
    {
        'nvimtools/none-ls.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local null_ls = require 'null-ls'
            local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
            null_ls.setup {
                debug = true,
                sources = {
                    null_ls.builtins.formatting.prettierd.with {
                        prefer_local = 'node_modules/.bin',
                        filetypes = {
                            'javascript',
                            'typescript',
                            'vue',
                            'css',
                            'scss',
                            'less',
                            'html',
                            'json',
                            'jsonc',
                            'yaml',
                            'markdown',
                            'graphql',
                            'handlebars',
                        },
                    },
                    null_ls.builtins.formatting.stylua,
                },
                on_attach = function(client, bufnr)
                    print('none-ls attached to buffer ' .. bufnr)
                    if client.supports_method 'textDocument/formatting' then
                        print('none-ls supports formatting for buffer ' .. bufnr)
                        -- Set up formatting on save
                        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format { bufnr = bufnr }
                            end,
                        })
                    else
                        print('none-ls does not support formatting for buffer ' .. bufnr)
                    end
                end,
            }
            vim.keymap.set('n', '<leader>f', function()
                vim.lsp.buf.format {
                    async = true,
                    filter = function(client)
                        return client.name == 'null-ls'
                    end,
                }
            end, { desc = 'Format file' })
        end,
    },
}
