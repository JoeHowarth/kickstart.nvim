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
    -- {
    --   'catppuccin/nvim',
    --   priority = 1000, -- Make sure to load this before all the other start plugins.
    --   init = function()
    --     -- vim.cmd.colorscheme 'catppuccin-latte'
    --
    --     vim.cmd.hi 'DiagnosticUnnecessary guifg=#737aa2'
    --     vim.cmd.hi 'Comment guifg=#7982a9 gui=italic'
    --   end,
    -- },

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    This is the easiest way to modularize your config.
    --
    --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
    { import = 'kickstart.plugins' },
    { import = 'custom.plugins' },
  }, {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
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
