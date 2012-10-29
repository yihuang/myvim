if has('gui_running')
    set guioptions -=T
endif

syntax enable
set hlsearch
set sw=4 ts=4 et
filetype plugin indent on

nnoremap ,e :e <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <C-L> :BufExplorer<CR>

call pathogen#infect()

set background=dark
colorscheme solarized
