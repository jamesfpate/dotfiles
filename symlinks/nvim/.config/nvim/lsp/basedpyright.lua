local M = {}

function M.setup()
  -- Create a simple filetype detection autocmd
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function(args)
      -- Define the config to be passed to vim.lsp.start
      local config = {
        name = 'basedpyright',
        cmd = {'basedpyright-langserver', '--stdio'},
        root_dir = vim.fs.dirname(vim.fs.find({'pyproject.toml', 'setup.py', '.git'}, {upward = true})[1]),
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true
            }
          }
        }
      }
      
      -- Start the language server with the config
      vim.lsp.start(config)
      
      -- Set up keymaps (these should only be set once per buffer)
      local bufnr = args.buf
      local opts = { noremap=true, silent=true, buffer=bufnr }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    end
  })
end

return M