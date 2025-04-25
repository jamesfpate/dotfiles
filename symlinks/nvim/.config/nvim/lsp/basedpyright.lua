return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  root_markers = { 
	'pyproject.toml', 'setup.py', '.git' },
  filetypes = { 'python' },
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
