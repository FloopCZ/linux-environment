" Use Vim settings instead of Vi.
set nocompatible

" Load indentation rules and plugins.
filetype plugin indent on

" Load vim-plug plugins.
" Don't forget to call `:PlugInstall`.
call plug#begin('~/.config/nvim/plugged')
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --system-libclang' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" Set-up YouCompleteMe.
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = ['~/.ycm_extra_conf.py']
" Do not use code diagnostics.
let g:ycm_show_diagnostics_ui = 0
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0
" Close the documentation window after insertion.
let g:ycm_autoclose_preview_window_after_insertion = 1

" Set-up airline.
" Do not check indentation.
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Use the system clipboard as the unnamed clipboard (simple inter-app copying).
set clipboard+=unnamedplus

" Use C-a to select all in visual mode (doesn't change the mode).
vmap <C-a> gg0oG$

" Use spaces instead of tabs.
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Turn off expandtab for editing makefiles.
autocmd FileType make setlocal noexpandtab

" base16 color scheme
set termguicolors
set background=dark
silent! colorscheme base16-solarized-dark
" Allow changing the background from dark to light using F5
function! ColorToggle()
    if (&background == "dark")
        colorscheme base16-solarized-light
        set background=light
    else
        colorscheme base16-solarized-dark
        set background=dark
    endif
endfunction
nnoremap <F5> :call ColorToggle()<CR>

" Syntax hightlighting.
syntax on

" Enable mouse usage (all modes).
set mouse=a

" Enable menus.
set wildmenu
set wildmode=longest:full,full

" For all text files set 'textwidth' to 78 characters.
" autocmd FileType text setlocal textwidth=78

" Jump to the last position when reopening a file.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Remember folds.
autocmd BufWinLeave *.* mkview!
autocmd BufWinEnter *.* silent! loadview

" Fold by indentation.
set foldmethod=syntax
" Do not fold by default.
set foldlevelstart=99

" Delete buffers that are not active.
autocmd BufEnter * setlocal bufhidden=delete

" Set some handy shorcuts for moving in tabs
nnoremap <S-l> gt
nnoremap <S-h> gT

" Disable search highlight of the last searched expression
nnoremap <CR>  :noh<CR><CR>
nnoremap <BS>  :noh<CR><BS>
nnoremap <C-L> :noh<CR><BS>

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Use extended regular expressions. This settings has problems with
" searching words whose last letter is `s`. e.g.
" s/words/worlds/ is interpreted as s/\vwords/\vworlds/
":nnoremap / /\v
":cnoremap s/ s/\v

" Other options.
set autochdir     " Change working directory to the one containing the file.
set showcmd       " Show (partial) command in status line.
set showmatch     " Show matching brackets.
set showmode      " Indicates input or replace mode at the bottom.
set ignorecase    " Case insensitive matching.
set smartcase     " Smart case matching (insensitive with lowercase pattern).
set incsearch     " Incremental search.
set autowrite     " Automatically save before commands like :next and :make.
set hidden        " Hide buffers when they are abandoned.
set ruler         " Show the cursor position all the time.
set hlsearch      " Highligt the last searched pattern.
set cmdheight=1   " Command line two lines high.
set autoread      " Watch for file changes.
set number        " Line numbers.
set scrolloff=3   " Keep few lines above/below.
set nowrap        " Do not wrap lines longer than the width of the screen.
set tabpagemax=90 " Raise a limit of opened tabs.
set breakindent   " Keep indentation when wrapping lines.

" Define some pretty whitespace chars
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:·

" Define :DiffOrig command - shows the difference between the edited file and
" the original
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Save a read-only opened file using sudo
cmap w!! %!sudo tee > /dev/null %

" Disable indentation on the current file
:nnoremap <F8> :setl noai nocin nosi inde=<CR>

" Arrows move through display lines instead of physical lines
map <silent> <Up> gk
imap <silent> <Up> <C-o>gk
map <silent> <Down> gj
imap <silent> <Down> <C-o>gj
map <silent> <home> g<home>
imap <silent> <home> <C-o>g<home>
map <silent> <End> g<End>
imap <silent> <End> <C-o>g<End>

" hjkl move through display lines instead of physical lines
noremap <silent> k gk
noremap <silent> j gj

" Ctrl-S saves file
noremap  <silent> <C-S>  :update<CR>
vnoremap <silent> <C-S>  <C-C>:update<CR>
inoremap <silent> <C-S>  <C-O>:update<CR>

" ClangFormat
map <C-F> :pyf /usr/share/clang/clang-format.py<cr>
imap <C-F> <c-o>:pyf /usr/share/clang/clang-format.py<cr>

" Fix https://github.com/neovim/neovim/issues/6403
set guicursor=
