
-- general config
vim.o.clipboard = "unnamedplus"
vim.o.fileencoding = "utf-8"
vim.wo.number = true
vim.wo.rnu = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
require("plugins")

vim.cmd[[colorscheme tokyonight-night]]
vim.cmd("let g:airline_theme='lucius'")
vim.cmd("let g:ctrlp_custom_ignore = '\\v[\\/](node_modules|venv|dist|build)|(\\.(swp|ico|git|svn))$'")

local remap = vim.api.nvim_set_keymap

local to_remap = {
 {"n", "j", "g"},
{"n", "J", "G"},
{"n", "jj", "gg"},
{"n", "h", "d"},
{"n", "hh", "dd"},
{"n", "s", "h"},
{"n", "d", "j"},
{"n", "f","k"},
{"n", "k","f"},
{"n", "K", "F"},
{"n", "g", "l"},
{"n", "<esc><esc>", "<cmd>noh<CR>"},

{"o", "f", "k"},
{"o", "s", "h"},
{"o", "f","k"},
{"o", "h", "d"},
{"o", "d", "j"},
{"o", "j", "g"},
{"o", "J", "G"},
{"o", "jj", "gg"},
{"o", "g", "l"},

{"v", "s", "h"},
{"v", "h", "d"},
{"v", "d", "j"},
{"v", "k", "f"},
{"v", "K", "F"},
{"v", "f", "k"},
{"v", "j", "g"},
{"v", "jj", "gg"},
{"v", "J", "G"},
{"v", "g", "l"}}
local remap_opts = {noremap = true, silent = true }
for _, binding in pairs(to_remap) do
    remap(binding[1], binding[2], binding[3], remap_opts)
end
-- local on_attach = function(client, bufnr)
-- 
-- end
local did_unbind = false
vim.api.nvim_create_autocmd('filetype', {
  pattern = 'netrw',
  desc = 'Better mappings for netrw',
  callback = function()
    local local_bind_no_remap = function(lhs, rhs)
      vim.keymap.set('n', lhs, rhs, {noremap = true, buffer = true})
    end 
    local umap = function(lhs)
      vim.keymap.del('n', lhs, {noremap = true, buffer = true})
    end

    local_bind_no_remap("s", "h")
    local_bind_no_remap("d", "j")
    local_bind_no_remap("f", "k")
    local_bind_no_remap("g", "l")
    local to_unmap = {"gp", "gn", "gh", "gf", "gd", "gb"}
    if(not did_unbind) then 
      for _, lhs in pairs(to_unmap) do
        umap(lhs)
      end
      did_unbind = true
    end
  end
})
