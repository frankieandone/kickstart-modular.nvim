return {
    {
        'MunifTanjim/prettier.nvim',
        event = { 'BufWritePre' },
        config = function()
            local prettier = require 'prettier'
            prettier.setup {
                bin = 'prettierd',
                filetypes = {
                    'typescript',
                },
                cli_options = {

                    arrowParens = 'always',
                    bracketLine = false,
                    bracketSameLine = false,
                    bracketSpacing = true,
                    -- Use eslint.config.js
                    config_precedence = 'prefer-file',
                    -- Use .editorconfig with highest precedence
                    editorconfig = true,
                    embedded = 'auto',
                    embeddedLanguageFormatting = 'auto',
                    experimentalTernaries = true,
                    htmlWhitespaceSensitivity = 'css',
                    interpolation = true,
                    printWidth = 100,
                    proseWrap = 'always',
                    semi = true,
                    singleAttributePerLine = true,
                    singleQuote = true,
                    trailingComma = 'all',
                    vueIndentScriptAndStyle = false,
                },
            }
        end,
    },
}
