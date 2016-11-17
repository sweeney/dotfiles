syntax on
set autoindent
set smartindent
set ruler
set hlsearch

" http://tedlogan.com/techblog3.html
set softtabstop=4
set shiftwidth=4
set expandtab


if has("autocmd")
        autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \ exe "normal g`\"" |
          \ endif
endif
