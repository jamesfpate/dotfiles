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
vim.g.mapleader = ";"
vim.g.maplocalleader = "\\"

-- keymap mini.pick
vim.keymap.set('n', '<leader>p', function() require('mini.pick').builtin.files() end, { desc = 'Pick files' })
vim.keymap.set('n', '<leader>pb', function() require('mini.pick').builtin.buffers() end, { desc = 'Pick buffers' })
vim.keymap.set('n', '<leader>pg', function() require('mini.pick').builtin.grep_live() end, { desc = 'Live grep' })

-- keymap mini.files
vim.keymap.set('n', '<leader>f', function()
  require('mini.files').open()
end, { desc = 'Open mini.files explorer' })

-- LSP keybindings
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Show References' })
vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Actions' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show Diagnostics' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous Diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })

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
    -- LSP and completion plugins
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
      },
      config = function()
        -- Autocompletion setup
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          }, {
            { name = 'buffer' },
          })
        })

        -- Enable autocompletion for specific file types
        vim.filetype.add({
          extension = {
            py = "python",
          },
        })
      end,
    },
    -- add more plugins here
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true, notify = false },
})
