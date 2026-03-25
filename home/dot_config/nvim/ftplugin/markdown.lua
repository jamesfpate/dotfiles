-- Markdown-specific settings
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- Optional additional settings for Markdown files
-- vim.opt_local.textwidth = 80  -- Soft wrap at 80 characters
vim.opt_local.wrap = true     -- Enable line wrapping
vim.opt_local.linebreak = true  -- Wrap at word boundaries, not in the middle of words
vim.opt_local.conceallevel = 0  -- Don't hide markdown syntax (0 = no concealing)
