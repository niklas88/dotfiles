-- Enable Mouse
vim.opt.mouse = "a"

-- Set Editor Font
if vim.fn.exists(':GuiFont') ~= 0 then
    -- Use GuiFont! to ignore font errors
    vim.cmd('GuiFont! BlexMono Nerd Font Medium:h11')
end

-- Disable GUI Tabline
if vim.fn.exists(':GuiTabline') ~= 0 then
    vim.cmd('GuiTabline 0')
end

-- Disable GUI Popupmenu
if vim.fn.exists(':GuiPopupmenu') ~= 0 then
    vim.cmd('GuiPopupmenu 0')
end

-- Enable GUI ScrollBar
if vim.fn.exists(':GuiScrollBar') ~= 0 then
    vim.cmd('GuiScrollBar 0')
end

-- Right Click Context Menu (Copy-Cut-Paste)
vim.keymap.set('n', '<RightMouse>', ':call GuiShowContextMenu()<CR>', { silent = true })
vim.keymap.set('i', '<RightMouse>', '<Esc>:call GuiShowContextMenu()<CR>', { silent = true })
vim.keymap.set('x', '<RightMouse>', ':call GuiShowContextMenu()<CR>gv', { silent = true })
vim.keymap.set('s', '<RightMouse>', '<C-G>:call GuiShowContextMenu()<CR>gv', { silent = true })
