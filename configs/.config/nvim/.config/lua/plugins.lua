vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'ctrlpvim/ctrlp.vim'
  use 'tpope/vim-fugitive'
end)
