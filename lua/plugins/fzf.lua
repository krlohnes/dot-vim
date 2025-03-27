vim.g.fzf_layout = {
    window = '-tabnew'
}
vim.g.fzf_action = { enter = 'tab split' }

return { 
    'junegunn/fzf.vim', 
    dependencies = { 'junegunn/fzf' }
}
