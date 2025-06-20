return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            },
        },
    },
    { 'Bilal2453/luvit-meta', lazy = true },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', version = 'v1.7.0', config = true },
            { 'williamboman/mason-lspconfig.nvim', version = 'v0.1.0', config = true },
            { 'WhoIsSethDaniel/mason-tool-installer.nvim', config = true },
            { 'j-hui/fidget.nvim', opts = {} },
            'hrsh7th/cmp-nvim-lsp',
            'nvimtools/none-ls.nvim',
            dependencies = { 'nvim-lua/plenary.nvim' },
        },
        config = function()
            -- Setup Mason first
            require('mason').setup()
            
            -- Setup Mason LSP Config
            require('mason-lspconfig').setup {
                ensure_installed = {
                    'lua_ls',
                },
            }

            -- Setup Mason Tool Installer
            require('mason-tool-installer').setup {
                ensure_installed = {
                    'stylua',
                    'eslint_d',
                    'prettierd',
                    'shfmt',
                },
                auto_update = true,
                run_on_start = true,
            }

            -- Setup LSP capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            -- Setup LSP servers
            local lspconfig = require('lspconfig')
            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    -- Disable formatting for LSP servers, as we're using null-ls for formatting
                    if client.name ~= 'null-ls' then
                        client.server_capabilities.documentFormattingProvider = false
                        client.server_capabilities.documentRangeFormattingProvider = false
                    end
                end,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = 'Replace',
                        },
                    },
                },
            }

            -- Setup LSP keymaps and autocommands
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')

                    -- Show diagnostics
                    vim.diagnostic.config {
                        virtual_text = false,
                        float = true,
                        signs = true,
                        underline = false,
                        update_in_insert = true,
                    }
                end,
            })
        end,
    },
}
-- vim: ts=2 sts=2 sw=2 et
