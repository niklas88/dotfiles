" Vim-Plug
call plug#begin('~/.config/nvim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'shaunsingh/seoul256.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'ojroques/nvim-osc52', {'branch': 'main'}
call plug#end()

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
set tabstop=8 shiftwidth=8 smarttab
set smartindent

" set colorcolumn=80
set linebreak
set list
set listchars=tab:▸\ ,eol:¬,trail:~
set background=dark
set mouse=nv
set omnifunc=syntaxcomplete#Complete

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

"" Quickfix navigation
map <C-j> :cn<CR>
map <C-k> :cp<CR>

" More logical Y (defaul was alias for yy)
nnoremap Y y$

" Don't yank to default register when changing something
nnoremap c "xc
xnoremap c "xc
" Don't yank to default register when pasting something
xnoremap p "_dp
xnoremap P "_dP

" # Filetype specifics
augroup filtypes
    autocmd!
    autocmd FileType matlab setlocal tabstop=4 shiftwidth=4 expandtab smartindent
    autocmd FileType c setlocal syntax=cpp.doxygen tabstop=8 shiftwidth=8 softtabstop=8 cc=100
    autocmd FileType javascript setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FileType tex command Latexmk execute "!latexmk -pdf %" 
augroup END

" Enable secure per directory options
set exrc
set secure

syntax on
"" Don't be disruptive with LSP hints
set signcolumn=no
let g:seoul256_disable_background = v:true
colo seoul256
highlight Normal ctermbg=none
highlight NonText ctermbg=none
let g:go_version_warning = 0

" Fuzzy-Finder Options
let g:fzf_action = { 'enter': 'tab split' }

" Clipboard
lua << EOF
local function osccopy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function oscpaste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

vim.g.clipboard = {
  name = 'osc52',
  copy = {
          ['+'] = osccopy,
          ['*'] = osccopy
          },
  paste = {
          ['+'] = oscpaste,
          ['*'] = oscpaste
  },
  cache_enabled = 1,
}

vim.opt.clipboard = "unnamedplus"

-- Setup language servers.
local lspconfig = require('lspconfig')

vim.diagnostic.config({
  float = {
    border = 'rounded',
  },
})

local function on_list(options)
  vim.fn.setqflist({}, ' ', options)
  vim.api.nvim_command('cfirst')
end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- Borders around hover and signatures
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
        {border = 'rounded'}
    )
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
      {border = 'rounded'}
    )

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'sh', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'gr', function()
        vim.lsp.buf.references(nil, {on_list=on_list})
    end, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

lspconfig.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
            check = {
                command = "clippy",
            },
        }
    }
})

lspconfig.clangd.setup({
    on_attach=on_attach,
})
EOF
