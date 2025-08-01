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

-- Enable line numbers
vim.wo.number = true        -- Show absolute line numbers
vim.wo.relativenumber = true -- Show relative line numbers

-- Auto-reload files when changed externally
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- mini.files keymap (using <leader>e to avoid conflicts)
vim.keymap.set('n', '<leader>e', function()
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

-- keymap lazygit
vim.keymap.set('n', '<leader>gg', function() require('snacks').lazygit.open() end, { desc = 'Open lazygit' })
vim.keymap.set('n', '<leader>gl', function() require('snacks').lazygit.log() end, { desc = 'Open lazygit log' })
vim.keymap.set('n', '<leader>gf', function() require('snacks').lazygit.log_file() end, { desc = 'Open lazygit file log' })

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

-- Configure diagnostics for all LSPs
vim.diagnostic.config({
  virtual_text = true,      -- Show inline diagnostics
  signs = true,            -- Show signs in the gutter
  underline = true,        -- Underline the problematic code
  update_in_insert = false, -- Don't update while typing
  severity_sort = false,   -- Don't sort by severity
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
      "tris203/precognition.nvim",
      opts = {
        startVisible = true,
        showBlankVirtLine = true,
        highlightColor = { link = "Comment" },
        hints = {
          Caret = { text = "^", prio = 2 },
          Dollar = { text = "$", prio = 1 },
          MatchingPair = { text = "%", prio = 5 },
          Zero = { text = "0", prio = 1 },
          w = { text = "w", prio = 10 },
          b = { text = "b", prio = 9 },
          e = { text = "e", prio = 8 },
          W = { text = "W", prio = 7 },
          B = { text = "B", prio = 6 },
          E = { text = "E", prio = 5 },
        },
        gutterHints = {
          G = { text = "G", prio = 10 },
          gg = { text = "gg", prio = 9 },
          PrevParagraph = { text = "{", prio = 8 },
          NextParagraph = { text = "}", prio = 8 },
        },
      },
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
        -- Don't set keymap here to avoid slowdown
      end,
    },
    {
      "echasnovski/mini.surround",
      version = false,
      config = function()
        require('mini.surround').setup({
          -- Add custom surroundings to be used on top of builtin ones
          custom_surroundings = nil,
          -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
          highlight_duration = 500,
          -- Module mappings
          mappings = {
            add = 'sa',            -- Add surrounding in Normal and Visual modes
            delete = 'sd',         -- Delete surrounding
            find = 'sf',           -- Find surrounding (to the right)
            find_left = 'sF',      -- Find surrounding (to the left)
            highlight = 'sh',      -- Highlight surrounding
            replace = 'sr',        -- Replace surrounding
            update_n_lines = 'sn', -- Update `n_lines`
            suffix_last = 'l',     -- Suffix to search with "prev" method
            suffix_next = 'n',     -- Suffix to search with "next" method
          },
          -- Number of lines within which surrounding is searched
          n_lines = 20,
          -- Whether to respect selection type
          respect_selection_type = false,
          -- How to search for surrounding
          search_method = 'cover',
          -- Whether to disable showing non-error feedback
          silent = false,
        })
      end,
    },
    {
      "sphamba/smear-cursor.nvim",
      version = false,
      config = function()
        require('smear_cursor').setup({
          -- Smear cursor when switching buffers or windows
          smear_between_buffers = true,
          -- Smear cursor when moving within line or to neighbor lines
          smear_between_neighbor_lines = true,
          -- Draw the smear in buffer space instead of screen space when scrolling
          scroll_buffer_space = true,
          -- Smear cursor in insert mode
          smear_insert_mode = true,
          -- Optimized settings for smooth movement
          stiffness = 0.8,                      -- Higher stiffness for snappier movement
          trailing_stiffness = 0.5,             -- Balanced trailing effect
          stiffness_insert_mode = 0.6,          -- Slightly smoother in insert mode
          trailing_stiffness_insert_mode = 0.6, -- Balanced trailing in insert mode
          distance_stop_animating = 0.5,        -- Stop animation at a reasonable distance
          time_interval = 7,                    -- Lower interval for smoother animation
        })
      end,
    },
    -- LSP and completion plugins
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
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
    -- Add snacks.nvim with lazygit
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      config = function()
        require("snacks").setup({
          lazygit = {
            configure = true,
            args = { "--use-config-file=/dev/null" },
            config = {
              os = { editPreset = "nvim-remote" },
              gui = {
                nerdFontsVersion = "3",
              },
            },
          },
          dashboard = {
            sections = {
              { section = "header" },
              {
                pane = 2,
                section = "terminal",
                cmd = "colorscript -e square",
                height = 5,
                padding = 1,
              },
              {
                section = "keys",
                gap = 1,
                padding = 1,
                keys = {
                  { icon = " ", key = "t", desc = "Find Files", action = ":Telescope find_files" },
                  { icon = " ", key = "e", desc = "File Explorer", action = ":lua require('mini.files').open()" },
                }
              },
              { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
              { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
              {
                pane = 2,
                icon = " ",
                title = "Git Status",
                section = "terminal",
                enabled = function()
                  return require("snacks").git.get_root() ~= nil
                end,
                cmd = "git status --short --branch --renames",
                height = 5,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              },
              { section = "startup" },
            },
          },
        })
      end,
    },
    --[[
    -- NeoCodeium AI completion
    {
      "monkoose/neocodeium",
      event = "VeryLazy",
      config = function()
        local neocodeium = require("neocodeium")
        neocodeium.setup({
          manual = true, -- This is key for nvim-cmp compatibility
        })
        -- Auto-close nvim-cmp when AI suggestions appear
        vim.api.nvim_create_autocmd("User", {
          pattern = "NeoCodeiumCompletionDisplayed",
          callback = function()
            require("cmp").abort()
          end
        })
        -- AI completion keybindings
        vim.keymap.set("n", "<leader>am", function()
          neocodeium.toggle()
        end, { desc = "Toggle AI completion mode" })

        vim.keymap.set("i", "<C-a>", function()
          neocodeium.cycle_or_complete()
        end, { desc = "Trigger AI completion" })
        vim.keymap.set("i", "<Tab>", function()
          if neocodeium.visible() then
            neocodeium.accept()
          else
            -- Fallback to regular tab behavior
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', false)
          end
        end, { desc = "Accept AI suggestion or insert tab" })
        vim.keymap.set("i", "<C-x>", function()
          neocodeium.clear()
        end, { desc = "Clear AI suggestion" })
      end
    },
    ]]
    -- Tree-sitter for better syntax highlighting
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          -- Automatically install missing parsers when entering buffer
          auto_install = true,
          -- Install parsers synchronously (only applied to `ensure_installed`)
          sync_install = false,
          -- List of parsers to ignore installing
          ignore_install = {},
          -- Ensure these language parsers are installed
          ensure_installed = {
            "lua", "vim", "vimdoc", "query", "regex",
            "python", "javascript", "typescript", "tsx",
            "go", "rust", "c", "cpp", "bash", "yaml",
            "json", "toml", "markdown", "markdown_inline",
            "html", "css", "dockerfile", "gitignore"
          },
          highlight = {
            enable = true,
            -- Disable slow treesitter highlight for large files
            disable = function(lang, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                return true
              end
            end,
          },
          indent = {
            enable = true
          },
        })
      end,
    },
    -- Telescope for file picking
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('telescope').setup({
          defaults = {
            file_ignore_patterns = {
              "node_modules", "build", "dist", "target/",
              "%.git/", "%.devbox/", "%.DS_Store", "%.cache/",
              "%.vscode/", "%.idea/", "%.swp", "%.swo",
              "package%-lock%.json", "yarn%.lock", "Cargo%.lock",
              "go%.sum", "go%.mod", "%.min%.js", "%.min%.css",
              "%.lock"  -- Ignore all .lock files
            },
          },
          pickers = {
            find_files = {
              hidden = true,  -- Include hidden files like .config
            },
          },
        })
        -- Telescope keymaps
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>t', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
        vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = 'Telescope grep string' })
        vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope diagnostics' })
      end
    },
    -- add more plugins here
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true, notify = false },
})

