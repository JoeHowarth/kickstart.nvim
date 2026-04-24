-- Highlight, edit, and navigate code (nvim-treesitter `main` branch).
--
-- The `main` branch is a full rewrite for Neovim 0.11+; it does NOT provide
-- `require('nvim-treesitter.configs').setup{}`. Highlight, indent, and folds
-- are opted into per-filetype via autocommands that call Neovim core APIs.
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- main branch does not support lazy loading
  build = ':TSUpdate',
  config = function()
    local nts = require 'nvim-treesitter'

    nts.setup {
      install_dir = vim.fn.stdpath 'data' .. '/site',
    }

    local parsers = {
      'bash',
      'c',
      'diff',
      'html',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'python',
      'rust',
      'typescript',
      'tsx',
      'javascript',
      'vim',
      'vimdoc',
    }
    nts.install(parsers)

    -- Start treesitter highlight on any filetype with a parser. pcall swallows
    -- the "no parser for X" error for filetypes we haven't installed.
    local indent_disable = { ruby = true }
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('user-treesitter-start', { clear = true }),
      callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end
        if not indent_disable[args.match] then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
