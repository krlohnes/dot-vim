" vint: -ProhibitSetNoCompatible
set nocompatible
set hidden
set showmatch
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
set tags=tags;/
set foldmethod=manual

let @t = '%s/\s\+$//e'

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
nnoremap ˙ <C-W>h
nnoremap ∆ <C-W>j
nnoremap ˚ <C-W>k
nnoremap ¬ <C-W>l

autocmd BufWinEnter * silent! :%foldopen!

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

filetype plugin indent on

function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

function! SetTab(n)
    let &shiftwidth=a:n
    let &tabstop=a:n
    let &softtabstop=a:n
endfunction


" Make gq wrap long blocks
map \gq ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>gq//-1<CR>
omap lp ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>//-1<CR>.<CR>

let g:vimpager_scrolloff = 0

" Use 2 space indents in yaml
autocmd FileType tsx,ts,yaml,html.handlebars,markdown setlocal
    \ shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType java,gradle,groovy setlocal
    \ shiftwidth=4 tabstop=4 softtabstop=4 tw=99
autocmd FileType java CocDisable
autocmd FileType scala,ruby,featurejs setlocal
    \ shiftwidth=2 tabstop=2 softtabstop=2 tw=99

set statusline+=%#warningmsg#
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

let g:syntastic_xml_checkers = ['xmllint']

let g:syntastic_ruby_exec = ['/usr/bin/ruby']

let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_open = 0

let g:syntastic_scala_checkers =['scalastyle']
let g:syntastic_scala_scalastyle_jar = '/usr/local/Cellar/scalastyle/0.8.0/libexec/scalastyle_2.11-0.8.0-batch.jar'
let g:syntastic_scala_scalastyle_config_file = '/usr/local/etc/scalastyle_config.xml'

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

function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/ge
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }

let g:fzf_action = {
  \ 'ctrl-m': 'tabedit',
  \ 'ctrl-o': 'e',
  \ 'ctrl-t': 'tabedit',
  \ 'ctrl-h':  'botright split',
  \ 'ctrl-v':  'vertical botright split' }

let g:fzf_action = {
  \ 'ctrl-m': 'tabedit',
  \ 'ctrl-o': 'e',
  \ 'ctrl-t': 'tabedit',
  \ 'ctrl-h':  'botright split',
  \ 'ctrl-v':  'vertical botright split' }

call plug#begin('~/.vim/plugged')
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'vim-syntastic/syntastic'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'tpope/vim-fugitive'
  Plug 'tfnico/vim-gradle'
  Plug 'derekwyatt/vim-scala'
  Plug 'sheerun/vim-polyglot'
  Plug 'tpope/vim-abolish'
call plug#end()

set statusline+=%{SyntasticStatuslineFlag()}
