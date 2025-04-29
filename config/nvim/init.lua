local vimrc = vim.fn.stdpath("config") .. "/vim.vimrc"
vim.cmd.source(vimrc)

require('lspconfig').ruff.setup({
  init_options = {
    settings = {
      -- Ruff language server settings go here
    }
  }
})
