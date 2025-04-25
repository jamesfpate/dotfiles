-- install lazy.nvim

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

-- Enable filetype detection and plugin loading
vim.cmd('filetype plugin indent on')

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- keymap mini.pick
vim.keymap.set('n', '<leader>p', function() require('mini.pick').builtin.files() end, { desc = 'Pick files' })
vim.keymap.set('n', '<leader>pb', function() require('mini.pick').builtin.buffers() end, { desc = 'Pick buffers' })
vim.keymap.set('n', '<leader>pg', function() require('mini.pick').builtin.grep_live() end, { desc = 'Live grep' })

-- keymap mini.files
vim.keymap.set('n', '<leader>f', function()
  require('mini.files').open()
end, { desc = 'Open mini.files explorer' })

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
    {
      "echasnovski/mini.pick",
      version = false,
      config = function()
        require('mini.pick').setup({
          -- Your mini.pick configuration options go here
        })
      end
    },
    {
      "echasnovski/mini.files",
      version = false,  -- Use development version
      config = function()
        require("mini.files").setup({
          -- Default mappings within the explorer
          mappings = {
            close = 'q',        -- Close explorer
            go_in = 'l',        -- Go into directory or open file
            go_in_plus = 'L',   -- Go into directory or open file in a new split
            go_out = 'h',       -- Go to parent directory
            go_out_plus = 'H',  -- Go to parent directory in new split
            reset = '<BS>',     -- Reset explorer to initial directory
            show_help = 'g?',   -- Show help
          },
          -- Explorer window options
          windows = {
            preview = true,     -- Show preview of file/directory under cursor
            width_focus = 30,   -- Width of focused window
            width_preview = 40, -- Width of preview window
          },
        })
      end,
    },
    -- add more plugins here
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true, notify = false },
})
