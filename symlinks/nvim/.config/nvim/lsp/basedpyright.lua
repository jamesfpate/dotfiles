vim.lsp.config['basedpyright'] = {
  -- Command and arguments to start the server
  cmd = { 'basedpyright-langserver', '--stdio' },
  
  -- Filetypes to automatically attach to
  filetypes = { 'python' },
  
  -- Root directory detection
  root_markers = { 'pyproject.toml', 'setup.py', '.git' },
  
  -- Server specific settings
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