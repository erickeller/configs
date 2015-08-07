set nocompatible

if !isdirectory(expand("~/.vim/bundle/vundle"))
  !mkdir -p ~/.vim/bundle
  !git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
endif

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" search
Bundle 'mileszs/ack.vim.git'

" tree explorer
Bundle 'scrooloose/nerdtree.git'
Bundle 'vim-scripts/The-NERD-tree.git'
Bundle 'majutsushi/tagbar.git'

" python plugins
Bundle 'ervandew/supertab.git'
Bundle 'vim-scripts/pep8.git'
Bundle 'fs111/pydoc.vim.git'
Bundle 'mitechie/pyflakes-pathogen.git'
Bundle 'wincent/Command-T.git'

" git plugin
Bundle 'tpope/vim-fugitive.git'
Bundle 'Valloric/YouCompleteMe'

" tabstops are 2 spaces and expanded
set smarttab
set tabstop=2
set softtabstop=2
set shiftwidth=2

autocmd Filetype sh setlocal ts=4 sts=4 sw=4
autocmd Filetype perl setlocal ts=4 sts=4 sw=4
autocmd Filetype python setlocal ts=4 sts=4 sw=4

set expandtab

if has("autocmd")
   filetype plugin indent on
endif

" automatically open tagbar
autocmd FileType c,cpp,h,hpp nested TagbarOpen

" strip trailing whitespaces with leader-sw and format file with leader-ff
" autocmd BufWritePre * :%s/\s\+$//e
autocmd FileType c,cpp,java,js,in,py,txt,sh,xml autocmd BufWritePre <buffer> :%s/\s\+$//e
nnoremap <silent> <leader>sw :call Preserve("%s/\\s\\+$//e")<CR>
nnoremap <silent> <leader>ff :call Preserve("normal gg=G")<CR>

function! Preserve(command)
    " preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" Some Linux distributions set filetype in /etc/vimrc.
" " Clear filetype flags before changing runtimepath to force Vim to reload
" them.
filetype on " try detect filetypes
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
" put syntax coloration on
syntax on

" pyflake
let g:pyflakes_use_quickfix = 0
" pep8
let g:pep8_map='<leader>8'

au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

map <leader>j :RopeGotoDefinition<CR>
map <leader>r :RopeRename<CR>

filetype plugin indent off
" search
nmap <leader>a <Esc>:Ack!
set spell
set background=dark
