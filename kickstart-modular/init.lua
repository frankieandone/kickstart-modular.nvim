-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.gfn = 'FiraCodeNerdFont:h10'

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
-- NOTE: install 256_noir using git clone https://github.com/andreasvc/vim-256noir.git and copy
-- over into "${XDG_CONFIG_HOME:-${HOME}/nvim/colors/256_noir.vim}" or https --download https://github.com/andreasvc/vim-256noir/blob/e8668a18a4a90272c1cae87e655f8bddc5ac3665/colors/256_noir.vim  into the same aforementioned file uri
vim.cmd 'colorscheme 256_noir'

-- Function to find the root directory
local function find_root_dir()
    local current_dir = vim.fn.getcwd()
    local root_dir = current_dir

    -- Check for common root indicators like .git
    while root_dir ~= '/' do
        if vim.fn.isdirectory(root_dir .. '/.git') == 1 then
            return root_dir
        end
        root_dir = vim.fn.fnamemodify(root_dir, ':h')
    end

    return current_dir
end

-- Function to restore session if file exists and conditions are met
local function restore_session()
    local root_dir = find_root_dir()
    local session_file = root_dir .. '/Session.vim'

    -- Get command line arguments
    local args = vim.fn.argv()

    -- Check if the session file exists and conditions for restoration are met
    if vim.fn.filereadable(session_file) == 1 then
        -- Avoid restoring session if a single file is passed as an argument
        if #args == 1 and vim.fn.filereadable(args[1]) == 1 then
            print 'Session not restored: A single file was opened'
        elseif vim.fn.getenv 'VIM_SERVERNAME' == vim.NIL then
            -- Source the session file if not called by an external tool
            vim.cmd('silent! source ' .. session_file)
            print('Session restored from ' .. session_file)
        else
            print 'Session not restored: Nvim called by an external tool'
        end
    else
        print('No session file found to restore in ' .. root_dir)
    end
end

-- Call the function to restore session
restore_session()
