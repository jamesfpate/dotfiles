-- Minimal config to test mini.pick
vim.g.mapleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Lazy.nvim not found, please run your normal config first")
  return
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "echasnovski/mini.pick",
    config = function()
      local pick = require('mini.pick')
      pick.setup()
      
      -- Time the file picker
      vim.keymap.set('n', '<leader>t', function()
        local start = vim.loop.hrtime()
        pick.builtin.files()
        vim.defer_fn(function()
          local elapsed = (vim.loop.hrtime() - start) / 1e9
          print('Files picker opened in: ' .. elapsed .. ' seconds')
        end, 50)
      end)
    end
  }
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
        "netrwPlugin", "matchit", "matchparen", "2html_plugin"
      }
    }
  }
})