call pathogen#infect()
filetype off
filetype plugin indent on

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
