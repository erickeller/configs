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

" tree explorer
Bundle 'scrooloose/nerdtree.git'
Bundle 'majutsushi/tagbar.git'

" tabstops are 2 spaces and expanded
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
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
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
" put syntax coloration on
syntax on

