-- Lua-specific settings
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smartindent = true

-- Configure Lua LSP
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
  globals = { "vim" }
}, vim.api.nvim_get_current_buf())
