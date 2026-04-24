return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git Diff' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Git file History' },
  },
}
