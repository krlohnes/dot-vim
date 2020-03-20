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
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'sheerun/vim-polyglot'
  Plug 'tpope/vim-abolish'
call plug#end()

set statusline+=%{SyntasticStatuslineFlag()}
hi CocErrorFloat ctermfg=Black guifg=#000000
" Conditionally enable this
" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
