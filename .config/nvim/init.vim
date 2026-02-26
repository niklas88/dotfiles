" Vim-Plug
call plug#begin('~/.config/nvim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'neovim/nvim-lspconfig'
Plug 'ggandor/leap.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'stevearc/oil.nvim'
Plug 'ibhagwan/fzf-lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'stevearc/conform.nvim'
call plug#end()

" formating options for text
" see http://vimcasts.org/episodes/hard-wrapping-text/ for more infos
set formatoptions=qrm1
set nowrap
set textwidth=79

filetype plugin on
filetype indent on

" UTF-8 is the one true encoding
set encoding=utf-8
set fileencoding=utf-8

" Line numbers
set number
set norelativenumber

" Default indentation
set smarttab
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

" Enable secure per directory options
set exrc
set secure

syntax on
"" Don't be disruptive with LSP hints
set signcolumn=number
highlight Normal ctermbg=none
highlight NonText ctermbg=none
set termguicolors
set laststatus=3

"" Go setup
let g:go_version_warning = 0

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

" Remappings
inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

" better identation
vnoremap < <gv
vnoremap > >gv

"" Cycling through Windows quicker.
nnoremap <A-Down>  <C-W><Down><C-W>_
nnoremap <A-Up>    <C-W><Up><C-W>_
nnoremap <A-Left>  <C-W><Left><C-W>|
nnoremap <A-Right> <C-W><Right><C-W>|

"" Quickfix navigation
nnoremap [q :cp<CR>
nnoremap ]q :cn<CR>

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
    autocmd FileType c setlocal syntax=cpp.doxygen tabstop=8 shiftwidth=8 softtabstop=8 cc=100
    autocmd FileType javascript setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FileType tex command Latexmk execute "!latexmk -pdf %" 
augroup END
let g:c_syntax_for_h = 1

" Lua Section
lua << EOF

vim.g.mapleader = " "

-- fzf-lua mappings
vim.keymap.set("n", "<leader>ff", require('fzf-lua').files, { desc = "Fzf Files" })
vim.keymap.set("n", "<leader>fg", require('fzf-lua').live_grep, { desc = "Fzf Live Grep" })
vim.keymap.set("n", "<leader>ft", require('fzf-lua').buffers, { desc = "Fzf Tabs" })
vim.keymap.set("n", "<leader>fh", require('fzf-lua').help_tags, { desc = "Fzf Help" })

-- oil.nvim for file browsing
require("oil").setup({
  keymaps = {
    ["g?"] = { "actions.show_help", mode = "n" },
    ["<CR>"] = {"actions.select", opts = {tab = true }},
    ["<C-s>"] = { "actions.select", opts = { vertical = true } },
    ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
    ["<C-o>"] = "actions.select",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = { "actions.close", mode = "n" },
    ["<C-l>"] = "actions.refresh",
    ["-"] = { "actions.parent", mode = "n" },
    ["_"] = { "actions.open_cwd", mode = "n" },
    ["`"] = { "actions.cd", mode = "n" },
    ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
    ["gs"] = { "actions.change_sort", mode = "n" },
    ["gx"] = "actions.open_external",
    ["g."] = { "actions.toggle_hidden", mode = "n" },
    ["g\\"] = { "actions.toggle_trash", mode = "n" },
  },
})

-- Clipboard
local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = paste,
    ['*'] = paste,
  },
}
vim.opt.clipboard = "unnamedplus"

--  Color --
require("catppuccin").setup({
    transparent_background = true, -- disables setting the background color.
})
vim.cmd.colorscheme "catppuccin"
-- Setup leap.nvim
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')
require('leap').opts.safe_labels = {}
-- Leap colors
vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = 'gray47' }) -- or some grey
vim.api.nvim_set_hl(0, 'LeapLabel', {
  fg = 'coral', bold = true, nocombine = true,
})

-- Setup lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = "catppuccin",
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch',
      {'diff', colored = false},
      {'diagnostics', colored = false}},
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {'fileformat'},
    lualine_c = {
      {'tabs',
        mode = 2,
        max_length = vim.o.columns,
        use_mode_colors = false,
        show_modified_status = true,
        symbols = {
          modified = '[+]',
         },
         tabs_color = {
         active = {fg = 'white'},
         inactive = {fg = 'gray'},
         }
      }
    },
    lualine_z = {'hostname'},
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

vim.diagnostic.config({
  float = {
    border = 'rounded',
  },
  virtual_text = true,
})

local function on_list(options)
  vim.fn.setqflist({}, ' ', options)
  vim.api.nvim_command('cfirst')
end

-- Global mappings for LSP things
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<F6>', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end, { silent = true, noremap = true })

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
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', function()
        vim.lsp.buf.references(nil, {on_list=on_list})
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'sh', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

vim.lsp.enable("rust_analyzer")
vim.lsp.enable("clangd")

-- conform
require("conform").setup({
    formatters_by_ft = {
        html = { "djlint" },
        htmldjango = { "djlint" },
        jinja = { "djlint" },
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt", lsp_format = "fallback" },
        c = { "clang-format", lsp_format = "fallback" },
        css = { "css_beautify" },
        yaml = { "yamlfmt" },
    },
})
vim.keymap.set({"n", "v"}, "<space>f", function()
    require("conform").format({ async = true, lsp_fallback = true })
end)

EOF
