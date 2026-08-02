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

require("lazy").setup({
    spec = {
        -- Fuzzy Finder ──────────────────────────────────────────────
        {
            "nvim-telescope/telescope.nvim",
            tag = "v0.1.9",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope-fzf-native.nvim",
            },
        },

        -- Syntax ────────────────────────────────────────────────────
        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

        -- Colorschemes ──────────────────────────────────────────────
        { "rose-pine/neovim", name = "rose-pine" },
        { "folke/tokyonight.nvim", name = "tokyonight" },

        -- Icons ─────────────────────────────────────────────────────
        { "echasnovski/mini.icons", version = "*", config = true },

        -- File Explorer ────────────────────────────────────────────
        {
            "echasnovski/mini.files",
            version = "*",
            keys = {
                { "<leader>mf", function() require("mini.files").open() end, desc = "Open file explorer" },
            },
            config = true,
        },

        -- Statusline ────────────────────────────────────────────────
        {
            "echasnovski/mini.statusline",
            version = "*",
            config = function()
                local statusline = require("mini.statusline")
                statusline.setup({ use_icons = true })
            end,
        },

        -- Pairs ─────────────────────────────────────────────────────
        { "echasnovski/mini.pairs", version = "*", config = true },

        -- Comment ───────────────────────────────────────────────────
        { "echasnovski/mini.comment", version = "*", config = true },

        -- Surround ──────────────────────────────────────────────────
        { "echasnovski/mini.surround", version = "*", config = true },

        -- Undo Tree ─────────────────────────────────────────────────
        { "mbbill/undotree" },

        -- LSP ───────────────────────────────────────────────────────
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },

        -- Completion ────────────────────────────────────────────────
        {
            "saghen/blink.cmp",
            version = "1.*",
            dependencies = { "rafamadriz/friendly-snippets" },
            opts = {
                keymap = { preset = "default" },
                appearance = { nerd_font_variant = "mono" },
                completion = { documentation = { auto_show = false } },
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },
                },
            },
            opts_extend = { "sources.default" },
        },

        -- Formatting ────────────────────────────────────────────────
        {
            "stevearc/conform.nvim",
            opts = {
                formatters_by_ft = {
                    c = { "clang_format" },
                    cpp = { "clang_format" },
                    css = { "prettierd" },
                    go = { "goimports", "gofumpt" },
                    html = { "prettierd" },
                    javascript = { "prettierd" },
                    json = { "prettierd" },
                    lua = { "stylua" },
                    python = { "ruff_format" },
                    rust = { "rustfmt" },
                    typescript = { "prettierd" },
                },
                format_on_save = {
                    lsp_format = "fallback",
                    timeout_ms = 500,
                },
            },
        },

        -- Git ───────────────────────────────────────────────────────
        {
            "lewis6991/gitsigns.nvim",
            opts = {
                signs = {
                    add = { text = "│" },
                    change = { text = "│" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    if not gs then return end

                    local function map(mode, lhs, rhs, opts_or_desc)
                        local opts = (type(opts_or_desc) == "string")
                            and { buffer = bufnr, desc = opts_or_desc }
                            or vim.tbl_extend("force", opts_or_desc or {}, { buffer = bufnr })
                        vim.keymap.set(mode, lhs, rhs, opts)
                    end

                    -- Hunk navigation
                    map("n", "]h", function()
                        if vim.wo.diff then return "]c" end
                        vim.schedule(gs.next_hunk)
                        return "<Ignore>"
                    end, { expr = true, desc = "Next hunk" })
                    map("n", "[h", function()
                        if vim.wo.diff then return "[c" end
                        vim.schedule(gs.prev_hunk)
                        return "<Ignore>"
                    end, { expr = true, desc = "Prev hunk" })

                    -- Hunk actions
                    map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
                    map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
                    map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
                    map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
                    map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")
                    map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
                    map("n", "<leader>gb", gs.blame_line, "Blame line")
                    map("n", "<leader>gd", gs.diffthis, "Diff this")
                    map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff this ~")

                    -- Text objects
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
                end,
            },
        },

        -- Keybinding hints ──────────────────────────────────────────
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {},
        },

        -- Motions
        -- Currently using vim-sneak. To try the modern alternative:
        --   { "folke/flash.nvim", event = "VeryLazy", opts = {} }
        -- flash.nvim: label-based jumping integrated with search / f t / LSP /
        --   treesitter. One plugin replaces sneak + enhances built-in motions.
        --   https://github.com/folke/flash.nvim
        { "justinmk/vim-sneak" },

        -- Linting ────────────────────────────────────────────────────
        {
            "mfussenegger/nvim-lint",
            event = { "BufReadPre", "BufNewFile" },
        },

        -- Indentation guides + scope indicator ──────────────────────
        {
            "echasnovski/mini.indentscope",
            version = "*",
            event = "VeryLazy",
            opts = function()
                return {
                    draw = {
                        delay = 100,
                        animation = require("mini.indentscope").gen_animation.none(),
                    },
                    symbol = "╎",
                }
            end,
        },

        -- Trailing whitespace ───────────────────────────────────────
        {
            "echasnovski/mini.trailspace",
            version = "*",
            event = "VeryLazy",
            config = function()
                local trailspace = require("mini.trailspace")
                trailspace.setup()
                vim.keymap.set("n", "<leader>tt", trailspace.trim, { desc = "Trim trailing whitespace" })
                vim.keymap.set("n", "<leader>tT", trailspace.trim_last_lines, { desc = "Trim trailing blank lines" })
            end,
        },

        -- Pattern highlighting (hex colours, TODO/FIXME, etc.) ─────
        {
            "echasnovski/mini.hipatterns",
            version = "*",
            event = "VeryLazy",
            opts = function()
                local hipatterns = require("mini.hipatterns")
                return {
                    highlighters = {
                        -- Hex colour codes visualised as their actual colour
                        hex_color = hipatterns.gen_highlighter.hex_color({ priority = 2000 }),
                        -- TODO / FIXME / HACK / NOTE / XXX with standout colours
                        todo = {
                            pattern = "TODO:",
                            group = "MiniHipatternsTodo",
                        },
                        fixme = {
                            pattern = "FIXME:",
                            group = "MiniHipatternsFixme",
                        },
                        hack = {
                            pattern = "HACK:",
                            group = "MiniHipatternsHack",
                        },
                        note = {
                            pattern = "NOTE:",
                            group = "MiniHipatternsNote",
                        },
                        xxx = {
                            pattern = "XXX:",
                            group = "MiniHipatternsFixme",
                        },
                    },
                }
            end,
        },
    },

    install = { colorscheme = { "tokyonight-night" } },
    checker = { enabled = true },
})