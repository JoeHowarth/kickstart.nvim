-- Load and setup core vim options and keymaps
require('kickstart.options').setup()
require('kickstart.keymaps').setup()

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Support yank to clipboard over ssh
local is_tmux_session = vim.env.TERM_PROGRAM == 'tmux' -- Tmux is its own clipboard provider which directly works.
-- TMUX documentation about its clipboard - https://github.com/tmux/tmux/wiki/Clipboard#the-clipboard
if vim.env.SSH_TTY and not is_tmux_session then
  local function paste()
    return { vim.fn.split(vim.fn.getreg '', '\n'), vim.fn.getregtype '' }
  end
  local osc52 = require 'vim.ui.clipboard.osc52'
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = osc52.copy '+',
      ['*'] = osc52.copy '*',
    },
    paste = {
      ['+'] = paste,
      ['*'] = paste,
    },
  }
end

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

if vim.g.vscode then
  -- VSCode extension
else
  -- ordinary Neovim

  --  To update plugins you can run
  --    :Lazy update
  require('lazy').setup({
    { 'williamboman/mason.nvim', config = true },
    {
      'folke/tokyonight.nvim',
      priority = 1000, -- Make sure to load this before all the other start plugins.
      init = function()
        -- Load the colorscheme here.
        -- Like many other themes, this one has different styles, and you could load
        -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
        vim.cmd.colorscheme 'tokyonight-night'
        -- vim.cmd.colorscheme 'tokyonight-day'
        vim.cmd.hi 'DiagnosticUnnecessary guifg=#737aa2'
        vim.cmd.hi 'Comment guifg=#7982a9 gui=italic'
      end,
    },
    {
      'catppuccin/nvim',
      priority = 999,
    },

    { import = 'kickstart.plugins' },
    { import = 'custom.plugins' },
  }, {
    ui = {
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  })

  -- The line beneath this is called `modeline`. See `:help modeline`
  -- vim: ts=2 sts=2 sw=2 et
end
