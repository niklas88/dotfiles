vim.g.mapleader = " "

-- Plugin Management with vim.pack (Neovim 0.12+)
vim.pack.add({
  'https://github.com/editorconfig/editorconfig-vim',
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  'https://github.com/neovim/nvim-lspconfig',
  'https://codeberg.org/andyg/leap.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/stevearc/conform.nvim',
})

-- General Options
vim.opt.formatoptions = "qrm1"
vim.opt.wrap = false
vim.opt.textwidth = 79
vim.opt.number = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', eol = '¬', trail = '~' }
vim.opt.background = "dark"
vim.opt.mouse = "nv"
vim.opt.omnifunc = "syntaxcomplete#Complete"
vim.opt.startofline = false
vim.opt.smartcase = true
vim.opt.showmode = false -- Handled by lualine
vim.opt.exrc = true
vim.opt.secure = true
vim.opt.signcolumn = "number"
vim.opt.termguicolors = true
vim.opt.laststatus = 3
vim.opt.completeopt = { "longest", "menuone" }

-- Colors
require("catppuccin").setup({
    transparent_background = true,
})
vim.cmd.colorscheme "catppuccin"

-- Highlights (after colorscheme)
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NonText', { bg = 'none' })

-- Custom Mappings
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', { silent = true })

-- Omnicomplete navigation
vim.keymap.set('i', '<C-j>', function()
  return vim.fn.pumvisible() ~= 0 and '<C-n>' or '<C-j>'
end, { expr = true, replace_keycodes = true })
vim.keymap.set('i', '<C-k>', function()
  return vim.fn.pumvisible() ~= 0 and '<C-p>' or '<C-k>'
end, { expr = true, replace_keycodes = true })

-- Better indentation
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Window navigation
vim.keymap.set('n', '<A-Down>', '<C-W><Down><C-W>_')
vim.keymap.set('n', '<A-Up>', '<C-W><Up><C-W>_')
vim.keymap.set('n', '<A-Left>', '<C-W><Left><C-W>|')
vim.keymap.set('n', '<A-Right>', '<C-W><Right><C-W>|')

-- Quickfix navigation
vim.keymap.set('n', '[q', ':cp<CR>')
vim.keymap.set('n', ']q', ':cn<CR>')

-- More logical Y
vim.keymap.set('n', 'Y', 'y$')

-- Don't yank to default register when changing/pasting
vim.keymap.set({'n', 'x'}, 'c', '"xc')
vim.keymap.set('x', 'p', '"_dp')
vim.keymap.set('x', 'P', '"_dP')

-- Autocommands
local filetypes_group = vim.api.nvim_create_augroup('filtypes', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = filetypes_group,
  pattern = 'c',
  callback = function()
    vim.opt_local.syntax = 'cpp.doxygen'
    vim.opt_local.tabstop = 8
    vim.opt_local.shiftwidth = 8
    vim.opt_local.softtabstop = 8
    vim.opt_local.colorcolumn = '100'
  end
})
vim.api.nvim_create_autocmd('FileType', {
  group = filetypes_group,
  pattern = 'javascript',
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end
})
vim.api.nvim_create_autocmd('FileType', {
  group = filetypes_group,
  pattern = 'tex',
  callback = function()
    vim.api.nvim_buf_create_user_command(0, 'Latexmk', function()
      vim.cmd('!latexmk -pdf %')
    end, {})
  end
})

-- fzf-lua mappings
vim.keymap.set("n", "<leader>ff", require('fzf-lua').files, { desc = "Fzf Files" })
vim.keymap.set("n", "<leader>fg", require('fzf-lua').live_grep, { desc = "Fzf Live Grep" })
vim.keymap.set("n", "<leader>ft", require('fzf-lua').buffers, { desc = "Fzf Tabs" })
vim.keymap.set("n", "<leader>fh", require('fzf-lua').help_tags, { desc = "Fzf Help" })

-- oil.nvim
require("oil").setup({
  keymaps = {
    ["<CR>"] = {"actions.select", opts = {tab = true }},
  },
})

-- Clipboard (OSC 52)
-- Using built-in provider for true bidirectional clipboard sharing
local osc52 = require('vim.ui.clipboard.osc52')
vim.g.clipboard = {
  name = 'OSC 52',
  copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*') },
  paste = { ['+'] = osc52.paste('+'), ['*'] = osc52.paste('*') },
}
vim.opt.clipboard = "unnamedplus"

-- leap.nvim
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')
require('leap').opts.safe_labels = {}
vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = 'gray47' })
vim.api.nvim_set_hl(0, 'LeapLabel', { fg = 'coral', bold = true, nocombine = true })

-- lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = require('catppuccin.utils.lualine'),
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = { statusline = {}, winbar = {} },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = { statusline = 1000, tabline = 1000, winbar = 1000 }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', {'diff', colored = false}, {'diagnostics', colored = false}},
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
        symbols = { modified = '[+]' },
        tabs_color = { active = {fg = 'white'}, inactive = {fg = 'gray'} }
      }
    },
    lualine_z = {'hostname'},
  },
}

vim.diagnostic.config({
  float = { border = 'rounded' },
  virtual_text = true,
})

-- LSP mappings
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<F6>', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', function()
        vim.lsp.buf.references(nil, {on_list=on_list})
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover({ border = 'rounded' })
    end, opts)
    vim.keymap.set('n', 'sh', function()
      vim.lsp.buf.signature_help({ border = 'rounded' })
    end, opts)
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
vim.lsp.enable("pyright")
vim.lsp.enable("gopls")
vim.lsp.enable("bashls")

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
