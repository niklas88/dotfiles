" Vim-Plug
call plug#begin('~/.config/nvim/plugged')
Plug 'fatih/vim-go'
Plug 'junegunn/seoul256.vim'
Plug 'funorpain/vim-cpplint'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
Plug 'neomake/neomake'
Plug 'jamessan/vim-gnupg'
" Add plugins to &runtimepath
call plug#end()

" Disable modeline for security
set nomodeline

" formating options for text
" see http://vimcasts.org/episodes/hard-wrapping-text/ for more infos
set formatoptions=qrn1
set nowrap
set textwidth=79

"" No need to be compatible with vi and lose features.
set nocompatible

filetype plugin on
filetype indent on

" UTF-8 is the one true encoding
set encoding=utf-8
set fileencoding=utf-8

" Line numbers
set number
set norelativenumber

" Set update time to 500 ms, convenient for taglists etc
set updatetime=500

" set shiftwidth to 2 by default
set tabstop=2 shiftwidth=2
set smartindent

" set colorcolumn=80
set linebreak
set list
set listchars=tab:▸\ ,eol:¬,trail:~

set background=dark
set clipboard+=unnamedplus
set mouse=nv
set omnifunc=syntaxcomplete#Complete

" Keep the horizontal cursor position when moving vertically.
set nostartofline

" better identation
vnoremap < <gv
vnoremap > >gv
" Better navigating through omnicomplete option list
" See http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim
set completeopt=longest,menuone
function! OmniPopup(action)
    if pumvisible()
        if a:action == 'j'
            return "\<C-N>"
        elseif a:action == 'k'
            return "\<C-P>"
        endif
    endif
    return a:action
endfunction
inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_start_length = 2

 " path to directory where library can be found
let g:clang_library_path='/usr/lib/'
let g:compilation_database="./build/compile_commands.json"
let g:clang_use_library= 1

" force vim-gnupg to use the correct GPG version
let g:GPGExecutable = "gpg2 --trust-model always"

inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
"set cursorline
" higligt mode
hi CursorLine   cterm=NONE ctermbg=darkred
hi UnderCursor  cterm=bold ctermfg=white
" highlight matching braces
set showmatch
" highlight search terms
set hlsearch
set smartcase
" no visual flash on error
set novisualbell
" don't beep
set noerrorbells
" show (partial) command in the last line of the screen
" this also shows visual selection info
set showcmd
" automatically update the buffer if file got updated
set autoread
" Show the mode (insert,replace,etc.)
set showmode
" # Folding ----------------------------------------------------------------- {{{
set foldlevelstart=3
set foldmethod=syntax
set foldnestmax=2
"}}}

"" Cycling through Windows quicker.
map <C-M> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <A-Down>  <C-W><Down><C-W>_
map <A-Up>    <C-W><Up><C-W>_
map <A-Left>  <C-W><Left><C-W>|
map <A-Right> <C-W><Right><C-W>|

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za
" More logical Y (defaul was alias for yy)
nnoremap Y y$

" # Filetype specifics

augroup filtypes
    autocmd FileType matlab setlocal tabstop=4 shiftwidth=4 expandtab smartindent

    " activate cpp and doxygen syntax for *.c and *.cpp files
    autocmd FileType cpp setlocal syntax=cpp.doxygen expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType c setlocal syntax=cpp.doxygen expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType javascript setlocal expandtab shiftwidth=2 softtabstop=2

    autocmd FileType tex setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FileType tex map <F5> :w<CR>:!latexmk -xelatex -pdf %<CR>

    autocmd FileType python autocmd! BufWritePost * Neomake pylint flake8 vulture mypy

augroup END


" Enable secure per directory options
set exrc
set secure

"" Syntax highlightning, but only for color terminals.
syntax on
"colo seoul256
set bg=dark
highlight Normal ctermbg=none
highlight NonText ctermbg=none
set guicursor=

" Whitespace at end of line in red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" Set hidden so we don't have to save a buffer when swtichting
set hidden

" Prepend copyriht notice
command! Copyright :0r ~/.config/nvim/copyright_header
" Feedback Template
command! Feedback :0r ~/.config/nvim/feedback_template | set expandtab
