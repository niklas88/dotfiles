" Vim-Plug
call plug#begin('~/.config/nvim/plugged')
   Plug 'fatih/vim-go'
   Plug 'junegunn/seoul256.vim'
   Plug 'editorconfig/editorconfig-vim'
   Plug 'neovim/nvim-lspconfig'
   Plug 'ray-x/lsp_signature.nvim'
call plug#end()

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

" Basics for normal text files
set tabstop=8 shiftwidth=8 smarttab
set smartindent
set linebreak
" Show tab, EOL and trailing
set list
set listchars=tab:▸\ ,eol:¬,trail:~
set background=dark
set clipboard+=unnamedplus
set mouse=nv
" Syntax and theme
syntax on
colo seoul256
highlight Normal ctermbg=none
highlight NonText ctermbg=none

" Don't yank to default register when changing something
nnoremap c "xc
xnoremap c "xc
" Don't yank to default register when pasting something
xnoremap p "_dp
xnoremap P "_dP

"" Keep the horizontal cursor position when moving vertically.
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
" Always show the info column to prevent jarring hide/appear
set signcolumn=yes

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
" Folding
set foldlevelstart=3
set foldmethod=syntax
set foldnestmax=2

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

" # Filetype specifics
augroup filtypes
    autocmd!
    autocmd FileType matlab setlocal tabstop=4 shiftwidth=4 expandtab smartindent
    autocmd FileType c setlocal syntax=cpp.doxygen tabstop=8 shiftwidth=8 softtabstop=8 cc=100 omnifunc=v:lua.vim.lsp.omnifunc
    autocmd FileType javascript setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FileType tex command latexmk execute "!latexmk -pdf %"
    autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
augroup END

" Enable secure per directory options
set exrc
set secure

lua <<EOF
require'lspconfig'.pyright.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.clangd.setup{}
require'lsp_signature'.setup{
	bind = true,
	floating_window = false,
	doc_lines = 0,
	padding = '',
	max_width = 128,
	hint_prefix = '',
	floating_window_off_x = 0,
	floating_window_off_y = 0,
	floating_window_above_cur_line = true,
	triggered_chars = '',
	toggle_key = '<C-s>',
	handler_opts = {
		border = "rounded"   -- double, rounded, single, shadow, none
	},
}
EOF
