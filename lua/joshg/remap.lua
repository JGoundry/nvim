-- Leader key and file explorer
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })

-- ── Quickfix ──────────────────────────────────────────────────────
vim.keymap.set("n", "<A-j>", "<cmd>cnext<CR>", { desc = "Next quickfix" })
vim.keymap.set("n", "<A-k>", "<cmd>cprev<CR>", { desc = "Prev quickfix" })

-- ── Window navigation ─────────────────────────────────────────────
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- ── Buffer navigation ─────────────────────────────────────────────
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- ── Diagnostic navigation ─────────────────────────────────────────
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics in location list" })

-- ── Toggles ───────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<CR>", { desc = "Toggle line wrap" })
vim.keymap.set("n", "<leader>tn", "<cmd>set number! relativenumber!<CR>", { desc = "Toggle line numbers" })
vim.keymap.set("n", "<leader>tc", function()
    vim.wo.colorcolumn = vim.wo.colorcolumn == "" and "80" or ""
end, { desc = "Toggle colorcolumn" })
vim.keymap.set("n", "<leader>tl", "<cmd>set cursorline!<CR>", { desc = "Toggle cursorline" })

-- ── Misc ──────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>ll", function() require("lint").try_lint() end, { desc = "Trigger linting" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
