return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ft = { 'markdown' },
  opts = {
    heading = {
      enabled = true,
      sign = false,
      icons = { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
    },
    code = {
      enabled = true,
      sign = false,
      style = 'full',
      width = 'block',
      min_width = 60,
    },
    bullet = {
      enabled = true,
    },
    checkbox = {
      enabled = true,
    },
    pipe_table = {
      enabled = true,
      style = 'full',
    },
  },
  keys = {
    { '<leader>mr', '<cmd>RenderMarkdown toggle<cr>', desc = '[M]arkdown [R]ender toggle' },
  },
}
