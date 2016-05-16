" vint: -ProhibitSetNoCompatible
set nocompatible
set showmatch
set esckeys
set autoindent
set expandtab
set tabstop=8
set shiftwidth=4
set softtabstop=4
set tw=79
set formatoptions+=t
set number
set ruler
set hlsearch
set bs=2
set fo-=t
set t_Co=256
set clipboard=unnamedplus

syntax on

" Turn off line number underlining
:hi LineNr NONE

" Toggle folding with f9
inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

" Remap O and o (Insert newline before and newline after) so that
" vim isn't left in insert mode after execution
nnoremap O O<esc>
nnoremap o o<esc>

augroup VimrcColors
au!
    autocmd ColorScheme * highlight OverLength ctermbg=red ctermfg=white
        \ guibg=#592929
    autocmd ColorScheme * highlight TrailingWhitespace ctermbg=red guibg=#592929
    autocmd ColorScheme * highlight Tabs ctermbg=green
augroup end

colorscheme pellands

function! HighlightWSErrors(hl_on)
    if a:hl_on
        let t:hl_ws_er_ol=matchadd('OverLength', '\%>80v.\+')
        let t:hl_ws_er_trlws=matchadd('TrailingWhitespace', '\s\+$')
        let t:hl_ws_er_tbs=matchadd('Tabs', '\t')
    else
        if exists('t:hl_ws_er_ol')
            call matchdelete(t:hl_ws_er_ol)
        endif

        if exists('t:hl_ws_er_trlws')
            call matchdelete(t:hl_ws_er_trlws)
        endif

        if exists('t:hl_ws_er_tbs')
            call matchdelete(t:hl_ws_er_tbs)
        endif
    endif
endfunction

function! ToggleHighlightWSErrors()
    let t:highlight_ws_errors = exists('t:highlight_ws_errors') ?
                              \ !t:highlight_ws_errors :
                              \ 1

    call HighlightWSErrors(t:highlight_ws_errors)
endfunction

function! SetIndentation(spcs)
    set tabstop=spcs
    set softtabstop=spcs
    set shiftwidth=spcs
endfunction

if has('cscope')
    cnoreabbrev <expr> csa
        \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs add'  : 'csa')
    cnoreabbrev <expr> csf
        \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs find' : 'csf')
    cnoreabbrev <expr> csk
        \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs kill' : 'csk')
    cnoreabbrev <expr> csr
        \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs reset' : 'csr')
    cnoreabbrev <expr> css
        \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs show' : 'css')
    cnoreabbrev <expr> csh
        \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs help' : 'csh')
endif

filetype plugin on

" Make gq wrap long blocks
map \gq ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>gq//-1<CR>
omap lp ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>//-1<CR>.<CR>

let g:vimpager_scrolloff = 0

" Use 2 space indents in yaml
autocmd FileType yaml,html.handlebars,markdown setlocal
    \ shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType java setlocal
    \ shiftwidth=2 tabstop=2 softtabstop=2 tw=99

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_aggregate_errors = 1

" Turn off flake8
let g:syntastic_python_checkers = ['python', 'pylint']

" Turn on eslint_d for js
let g:syntastic_javascript_checkers = ['jscs']
" let g:syntastic_javascript_eslint_exec = 'eslint_d'

" pip install vim-vint to install vint
let g:syntastic_vim_checkers = ['vint']

" apt-get install ghc cabal && cabal update && cabal install shellcheck
let g:syntastic_sh_checkers = ['shellcheck']

" npm install -g js-yaml
let g:syntastic_yaml_checkers = ['jsyaml']

let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_open = 1

function! ToggleSyntastic(buf_path)
    let b:syntastic_mode = 'passive'

" Syntastic is off by default, this turns it on if a file named
" '.enable_syntastic' is found in cwd or any ancestor directory

python << EOF
import vim
import os.path

current_path = os.path.normpath(vim.eval('a:buf_path'))

while current_path != '/':
    if os.path.isfile(os.path.join(current_path, '.enable_syntastic')):
        vim.command('let b:syntastic_mode = "active"')
        break

    current_path = os.path.normpath(os.path.join(current_path, '..'))

EOF
endfunction

autocmd BufReadPre * call ToggleSyntastic(expand('%:p:h'))

" Fix airline statuses
set laststatus=2

" Use powerlineish theme with powerline hacked fonts
let g:airline_powerline_fonts = 1
let g:airline_theme='powerlineish'

" Enable Airline integration with fugitive
let g:airline#extensions#branch#enabled = 1

" change the text for when no branch is detected
let g:airline#extensions#branch#empty_message = ''

"truncate long branch names to a fixed length
let g:airline#extensions#branch#displayed_head_limit = 10

" vim-polyglot uses tpope/vim-markdown, plasticboy is better
let g:polyglot_disabled = ['markdown']

" Stop vim-markdown from autofolding markdown on every write
let g:vim_markdown_folding_disabled = 1

" neovim stuff

if has('nvim')
    " remap terminal buffer escape to escape key
    tnoremap <Esc> <C-\><C-n>

    " make some mappings to make moving around terminal buffers easier
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l
endif

execute pathogen#infect()