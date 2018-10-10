call pathogen#infect()

" temporary fix
" https://github.com/vim/vim/issues/3117
if has('python3')
  silent! python3 1
endif

let mapleader = ","

filetype off
filetype plugin indent on

if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
  set t_Co=256
endif

set tw=128
"set fo-=l
"set fo+=t

syntax enable
syntax on
if has('gui_running')
    set guioptions-=m
    set guioptions-=T
    set guifont=Monaco\ for\ Powerline:h11
else
end
colorscheme solarized
set background=dark
set laststatus=2
set fileencodings=utf-8,gbk
set hlsearch
set incsearch
set sw=4 ts=4 et
set diffopt=filler,horizontal
filetype plugin indent on

nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>
nmap <C-L> :BufExplorer<CR>
nmap <Leader>tt :TagbarToggle<CR>
nmap <Leader>2 Oimport pdb;pdb.set_trace()<ESC>
nmap <C-p> :CtrlP<CR>
nmap <silent> <leader>u :GundoToggle<CR>

let g:Powerline_symbols = 'fancy'
let g:session_autosave = 'yes'
let g:session_autoload = 'no'
let g:proj_flags="imstcg"

au BufNewFile,BufRead *.py set foldmethod=indent foldnestmax=2
au BufNewFile,BufRead *.lua set foldmethod=indent foldnestmax=2
au Filetype html,xml,xsl source ~/.vim/scripts/closetag.vim 

autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
autocmd BufWrite *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&"

nmap <Leader>l :setlocal number!<CR>
nmap <Leader>o :set paste!<CR>

nnoremap j gj
nnoremap k gk

let g:ctrlp_map = '<Leader>;'
let g:ctrlp_match_window_bottom = 1
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0

let g:airline_powerline_fonts = 1

" Source the vimrc file after saving it
augroup sourcing
  autocmd!
  autocmd bufwritepost .vimrc source $MYVIMRC
augroup END

" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

nmap <leader>y "*y
vmap <leader>y "*y
nmap <leader>d "*d
vmap <leader>d "*d
nmap <leader>p "*p
vmap <leader>p "*p

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.' . a:extra_filter)
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>
" Return to last edit position when opening files (You want this!)
augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END
" Remember info about open buffers on close
set viminfo^=%

nmap <silent> <leader><cr> :noh\|hi Cursor guibg=red<cr>
augroup haskell
  autocmd!
  autocmd FileType haskell map <silent> <leader><cr> :noh<cr>:GhcModTypeClear<cr>:SyntasticReset<cr>:HdevtoolsClear<cr>
augroup END

set tags=tags;/,codex.tags;/
" Generate haskell tags with codex and hscope
map <leader>tg :!codex update --force<CR>:call system("git-hscope -X TemplateHaskell")<CR><CR>:call LoadHscope()<CR>

autocmd FileType haskell set csprg=~/.local/bin/hscope
set csto=1 " search codex tags first
set cst
set csverb
nnoremap <silent> <C-\> :cs find c <C-R>=expand("<cword>")<CR><CR>

" Automatically make cscope connections
function! LoadHscope()
  let db = findfile("hscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/hscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /*.hs call LoadHscope()

" Show types in completion suggestions
let g:necoghc_enable_detailed_browse = 1
" Resolve ghcmod base directory
au FileType haskell let g:ghcmod_use_basedir = getcwd()

function! Pointfree()
  call setline('.', split(system('pointfree '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
endfunction

function! Pointful()
  call setline('.', split(system('pointful '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
endfunction

let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['haskell'] }
let g:syntastic_haskell_hdevtools_args = '-g-Wall'
let g:syntastic_cpp_compiler_options = '-std=c++14'
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++14 -stdlib=libc++'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_cpp_checkers = "cpplint"
let g:syntastic_python_checkers = ['flake8']

function! InsertGates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call InsertGates()

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" `gf` jumps to the filename under the cursor.  Point at an import statement
" and jump to it!
python3 << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF

" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

let g:ycm_server_keep_logfmles = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '/Users/yihuang/.ycm_extra_conf.py'
" let g:loaded_youcompleteme = 1

let g:DoxygenToolkit_authorName="HuangYi, Boyaa Inc."
let g:DoxygenToolkit_versionString="1.0"

vmap zgq command Zhwrap

au BufWritePost *.hs            silent !init-tags %
au BufWritePost *.hsc           silent !init-tags %

map [[ ?{<CR>w99[{
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
map [] k$][%?}<CR>

let g:tagbar_type_rust = {
            \ 'ctagstype' : 'rust',
            \ 'kinds' : [
            \'T:types,type definitions',
            \'f:functions,function definitions',
            \'g:enum,enumeration names',
            \'s:structure names',
            \'m:modules,module names',
            \'c:consts,static constants',
            \'t:traits,traits',
            \'i:impls,trait implementations',
            \]
            \}

" If you use qualified tags, then you have to change iskeyword to include
" a dot.  Unfortunately, that affects a lot of other commands, such as
" w, and \< \> regexes used by * and #.  For me, this is confusing because
" it's inconsistent with vim keys everywhere else.
" This binding temporarily modifies iskeyword just for the ^] command.
" nnoremap <silent> <c-]> :setl iskeyword=@,_,48-57,39<cr><c-]>
"     \:setl iskeyword=@,48-57,_,192-255<cr>

let g:hindent_on_save = 0

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
