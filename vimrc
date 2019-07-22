autocmd!
execute pathogen#infect()

set nocompatible                  " Modern VIM.

set background=dark               " Dark backgrounds ftw.
set t_Co=256                      " 256 colors.
colors deus

syntax enable                     " Turn on syntax highlighting.
filetype plugin indent on         " Turn on file type detection.

set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.

set backspace=indent,eol,start    " Intuitive backspacing.

set hidden                        " Handle multiple buffers better.

set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.

set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.

set number                        " Show line numbers.
set ruler                         " Show cursor position.

set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.

set wrap                          " Turn on line wrapping.
set scrolloff=3                   " Show 3 lines of context around the cursor.

set title                         " Set the terminal's title

set visualbell                    " No beeping.

set nobackup                      " Don't make a backup before overwriting a file.
set nowritebackup                 " And again.
set directory=$HOME/.vim/swapfiles// " Keep swap files in one location
set wildignore=bin,include,lib,.git,*.pyc " Ignore virtualenv / git files

set tabstop=2                    " Global tab width.
set shiftwidth=2                 " And again, related.
set expandtab                    " Use spaces instead of tabs

set list                         " Show tab characters.
set listchars=tab:>-,trail:~     " Show tabs and trailing whitespace.

autocmd FileType go setlocal noexpandtab " Tabs for Go

" Trim trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

set laststatus=2                  " Show the status line all the time
" Useful status information at bottom of screen
set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)

" Ctrl-P should ignore node_modules
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

" Shortcuts
let mapleader = ","
" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Remap escape to jj
inoremap jj <ESC>
inoremap `` <ESC>

" Emmet default key
let g:user_emmet_leader_key='<c-e>'

" Syntastic always use c++11
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'

