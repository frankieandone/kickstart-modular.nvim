-- Set up package manager
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

-- Install Lazy.nvim if not present
if not vim.loop.fs_stat(vim.fn.stdpath("data") .. "/lazy/lazy.nvim") then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
  })
end

-- Load Lazy.nvim and configure it
require("lazy").setup({
  -- Add your plugins here
})

