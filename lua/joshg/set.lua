vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- Crash recovery
vim.opt.swapfile = true
vim.opt.directory = vim.fn.stdpath("state") .. "/swap//"
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup//"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo//"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Display
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.splitright = true
vim.opt.showmode = false  -- statusline shows mode, built-in is redundant

-- Mouse — enables clicking, dragging, scrolling in all modes (n/v/i/c)
vim.opt.mouse = "a"

-- System clipboard (requires +clipboard and xclip/wl-clipboard)
vim.opt.clipboard = "unnamedplus"

-- Faster response for CursorHold (used by which-key, gitsigns, etc.)
vim.opt.updatetime = 300
vim.opt.isfname:append("@-@")

-- LSP diagnostic display
vim.diagnostic.config({
    signs = true,
    severity_sort = true,
    virtual_text = true,
    float = {
        border = "rounded",
        wrap = true,
        max_width = 80,
    },
})
