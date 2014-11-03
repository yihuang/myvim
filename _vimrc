call pathogen#infect()

let mapleader = ";"

filetype off
filetype plugin indent on

if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
  set t_Co=256
endif

set guifont="Monaco for Powerline 10"
syntax enable
syntax on
if has('gui_running')
    set guioptions-=m
    set guioptions-=T
else
end
colorscheme solarized
set background=dark
set laststatus=2
set fileencodings=utf-8,gbk
set hlsearch
set incsearch
set sw=4 ts=4 et
filetype plugin indent on

nnoremap ,e :e <C-R>=expand('%:p:h') . '/'<CR>
nmap <C-L> :BufExplorer<CR>
nmap <F11> :TagbarToggle<CR>
nmap <F3> :GundoToggle<CR>
nmap <F2> Oimport pdb;pdb.set_trace()<ESC>

let g:Powerline_symbols = 'fancy'
let g:session_autosave = 'yes'
let g:session_autoload = 'no'
let g:proj_flags="imstcg"

au BufNewFile,BufRead *.py set foldmethod=indent foldnestmax=2
au BufNewFile,BufRead *.lua set foldmethod=indent foldnestmax=2
au Filetype html,xml,xsl source ~/.vim/scripts/closetag.vim 

nmap <C-n> :bnext<CR>
nmap <C-p> :bprev<CR>

nmap <Leader>l :setlocal number!<CR>
nmap <Leader>o :set paste!<CR>
nmap <Leader>q :nohlsearch<CR>

nnoremap j gj
nnoremap k gk

let g:ctrlp_map = '<Leader>;'
let g:ctrlp_match_window_bottom = 1
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0
