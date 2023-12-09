" Install vimplug if not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" General Settings
set encoding=UTF-8 nobackup nowritebackup nocursorline splitbelow splitright wildmode=longest,list,full
set shiftwidth=4 tabstop=4 softtabstop=4 autoindent smartindent expandtab

" Key-bindings
let mapleader=" "

" Source command
nnoremap <leader>s :source ~/.vimrc<CR>
nnoremap <leader>x :Explore<CR>
nnoremap <leader>n :set invnu invrnu<CR>

" Splits in NORMAL mode
nmap <silent> <C-Up> :wincmd k<CR>
nmap <silent> <C-Down> :wincmd j<CR>
nmap <silent> <C-Left> :wincmd h<CR>
nmap <silent> <C-Right> :wincmd l<CR>

" Move lines up (down) in visual mode with Ctrl-Up (Ctrl-Down)
xnoremap <C-Up> :move '<-2<CR>gv-gv
xnoremap <C-Down> :move '>+1<CR>gv-gv

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'mboughaba/i3config.vim'
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-css-color'
Plug 'arcticicestudio/nord-vim'

call plug#end()

" i3 config syntax highlight
aug i3config_ft_detection
  au!
  au BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
aug end

" General look and feel
set number
set relativenumber

" Ligtline
let g:lightline = {
       \ 'colorscheme': 'nord'
       \ }

" Colorscheme
colorscheme nord
