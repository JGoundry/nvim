-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            "nvim-telescope/telescope.nvim", tag = "v0.1.9",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope-fzf-native.nvim",
                "nvim-tree/nvim-web-devicons"
                -- Needs to be installed on system not in nvim
                -- "BurntSushi/ripgrep",
                -- "sharkdp/fd",
            }

        },
        {
            "nvim-treesitter/nvim-treesitter", build = ":TSUpdate"
        },
        {
            "rose-pine/neovim", name = "rose-pine"
        },
        {
            "folke/tokyonight.nvim", name = "tokyonight"
        },
        {
            "mbbill/undotree"
        },
        {
            "vim-airline/vim-airline"
        },
        {
            "neovim/nvim-lspconfig"
        },
        {
            "williamboman/mason.nvim"
        },
        {
            "williamboman/mason-lspconfig.nvim"
        },
        {
            "hrsh7th/nvim-cmp"
        },
        {
            "hrsh7th/cmp-nvim-lsp"
        },
        {
            "machakann/vim-highlightedyank"
        },
        {
            "tpope/vim-commentary"
        },
        {
            "tpope/vim-surround"
        },
        {
            "justinmk/vim-sneak"
        },
        {
            "windwp/nvim-autopairs", event = "InsertEnter", config = true
        },
    },
    install = { colorscheme = { "tokyonight-night" } },
    checker = { enabled = true },
})
