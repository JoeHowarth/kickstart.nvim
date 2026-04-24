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
    { 'luarocks/hererocks', build = 'rockspec', lazy = true },
    { 'folke/tokyonight.nvim', priority = 1000 },
    { 'catppuccin/nvim', name = 'catppuccin', priority = 999 },
    { 'rose-pine/neovim', name = 'rose-pine' },
    { 'rebelot/kanagawa.nvim' },
    { 'sainnhe/everforest' },
    { 'ellisonleao/gruvbox.nvim' },
    {
      'zaldih/themery.nvim',
      lazy = false,
      opts = {
        themes = {
          { name = 'Tokyo Night', colorscheme = 'tokyonight' },
          -- { name = 'Tokyo Night Storm', colorscheme = 'tokyonight-storm' },
          -- { name = 'Tokyo Night Moon', colorscheme = 'tokyonight-moon' },
          { name = 'Tokyo Night Day', colorscheme = 'tokyonight-day' },
          -- { name = 'Catppuccin Mocha', colorscheme = 'catppuccin-mocha' },
          { name = 'Catppuccin Latte', colorscheme = 'catppuccin-latte' },
          -- { name = 'Catppuccin Macchiato', colorscheme = 'catppuccin-macchiato' },
          -- { name = 'Catppuccin Frappe', colorscheme = 'catppuccin-frappe' },
          -- { name = 'Rosé Pine', colorscheme = 'rose-pine' },
          { name = 'Rosé Pine Dawn', colorscheme = 'rose-pine-dawn' },
          -- { name = 'Rosé Pine Moon', colorscheme = 'rose-pine-moon' },
          -- { name = 'Kanagawa', colorscheme = 'kanagawa' },
          { name = 'Kanagawa Lotus', colorscheme = 'kanagawa-lotus' },
          -- { name = 'Kanagawa Dragon', colorscheme = 'kanagawa-dragon' },
          -- { name = 'Everforest', colorscheme = 'everforest' },
          -- { name = 'Gruvbox Dark', colorscheme = 'gruvbox' },
        },
        livePreview = true,
      },
      keys = {
        { '<leader>ct', '<cmd>Themery<cr>', desc = '[C]olor [T]heme picker' },
      },
      init = function()
        -- Load persisted theme or fall back to tokyonight
        local themery_state = vim.fn.stdpath 'data' .. '/themery.json'
        if vim.fn.filereadable(themery_state) == 0 then
          vim.cmd.colorscheme 'tokyonight'
        end
      end,
    },

    { import = 'kickstart.plugins' },
    { import = 'custom.plugins' },
  }, {
    rocks = {
      hererocks = true,
    },
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
