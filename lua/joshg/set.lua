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
vim.opt.backup = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

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

-- Mouse — enables clicking, dragging, scrolling in all modes (n/v/i/c)
vim.opt.mouse = "a"

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