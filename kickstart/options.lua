-- Set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.background = 'dark'
vim.opt.backspace = 'indent,eol,start'
vim.opt.backupdir = '/tmp//,.'
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.colorcolumn = '96'
vim.opt.cursorline = true
vim.opt.cursorlineopt = { 'number', 'line' }
vim.opt.expandtab = true
vim.opt.formatoptions:append 't'
vim.opt.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50'
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = 'split'
vim.opt.incsearch = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 4
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.showtabline = 2
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.textwidth = 100
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 250

-- Set clipboard based on OS
if vim.fn.has 'unix' == 1 then
    local uname = vim.fn.system('uname -s'):gsub('\n', '')
    if uname == 'Darwin' then
        vim.opt.clipboard = 'unnamed'
    else
        vim.opt.clipboard = 'unnamedplus'
    end
end

-- Set termguicolors if not in Apple Terminal
if not string.match(vim.env.TERM_PROGRAM or '', 'Apple_Terminal') then
    vim.opt.termguicolors = true
end

-- Set colorscheme
vim.cmd 'colorscheme habamax'

-- Enable syntax
vim.cmd 'syntax on'

-- Set highlight groups
vim.api.nvim_set_hl(0, 'Normal', { bg = '#080808' })
vim.api.nvim_set_hl(0, 'Visual', { bold = true, fg = 'NONE', bg = '#262626' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffffff' })
vim.api.nvim_set_hl(0, 'TabLineFill', { bg = '#080808' })
vim.api.nvim_set_hl(0, 'TabLine', { fg = '#5f5fff', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TabLineSel', { fg = '#ffffff', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#1c1c1c' })
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#1c1c1c' })

-- Add FZF to runtimepath
vim.opt.rtp:append '/opt/homebrew/opt/fzf'

print 'loaded options.lua'
