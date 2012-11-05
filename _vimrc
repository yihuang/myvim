syntax enable
syntax on
if has('gui_running')
    set guioptions-=m
    set guioptions-=T
    colorscheme solarized
else
end
set background=dark
set fileencodings=utf-8,gbk
set hlsearch
set sw=4 ts=4 et
filetype plugin indent on

nnoremap ,e :e <C-R>=expand('%:p:h') . '/'<CR>
nmap <C-L> :BufExplorer<CR>
nmap <F8> :TagbarToggle<CR>

call pathogen#infect()

let g:Powerline_symbols = 'fancy'
let g:session_autosave = 'yes'
let g:session_autoload = 'no'
let g:proj_flags="imstcg"
