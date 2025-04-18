-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Enable LSPs
vim.lsp.enable({
	'basedpyright',
	'luals',
	'gopls',
	'typescript',
	'eslint',
	'tailwind',
	'svelte',
	'yaml',
	'bash',
	'dockerfile',
	'templ',
	'css'
})

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add Tokyonight theme
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd[[colorscheme tokyonight]]
      end
    },
    -- add more plugins here
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true, notify = false },
})
