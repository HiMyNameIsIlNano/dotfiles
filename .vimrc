"Install vimplug if not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"General Settings
set encoding=UTF-8 nobackup nowritebackup nocursorline splitbelow splitright wildmode=longest,list,full
set shiftwidth=4 tabstop=4 softtabstop=4 autoindent smartindent expandtab

"Key-bindings
let mapleader=" "

"source command
nnoremap <leader>s :source ~/.vimrc<CR>
nnoremap <leader>x :Explore<CR>
nnoremap <leader>n :set invnu invrnu<CR>

"splits in NORMAL mode
nmap <silent> <C-Up> :wincmd k<CR>
nmap <silent> <C-Down> :wincmd j<CR>
nmap <silent> <C-Left> :wincmd h<CR>
nmap <silent> <C-Right> :wincmd l<CR>

"move lines up (down) in visual mode with Ctrl-Up (Ctrl-Down)
xnoremap <C-Up> :move '<-2<CR>gv-gv
xnoremap <C-Down> :move '>+1<CR>gv-gv

"Plugins
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ap/vim-css-color'
Plug 'mboughaba/i3config.vim'

call plug#end()

"Color Scheme
set termguicolors

"Airline
let g:airline_theme='luna'
