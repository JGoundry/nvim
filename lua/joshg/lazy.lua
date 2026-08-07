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
            tag = "v0.2.2",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope-fzf-native.nvim",
            },
        },

        -- Syntax ────────────────────────────────────────────────────
        --
        -- PINNED to the archived "master" branch for Neovim 0.11
        -- compatibility. The "main" branch requires a different API
        -- (module renamed to require("nvim-treesitter"), explicit
        -- FileType autocmds for vim.treesitter.start() + indentexpr,
        -- and tree-sitter CLI on PATH).
        --
        -- This config is an 0.11 config. On 0.12+ treesitter is
        -- built-in — remove this plugin entirely and delete
        -- after/plugin/treesitter.lua. See REFERENCE.md § "Migration".
        {
            "nvim-treesitter/nvim-treesitter",
            branch = "master",
            build = ":TSUpdate",
        },

        -- Colorschemes ──────────────────────────────────────────────
        { "rose-pine/neovim", name = "rose-pine" },
        { "folke/tokyonight.nvim", name = "tokyonight" },

        -- Icons ─────────────────────────────────────────────────────
        { "echasnovski/mini.icons", version = "*", config = true },

        -- Notifications ─────────────────────────────────────────────
        { "echasnovski/mini.notify", version = "*", config = true },

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
        {
            "mbbill/undotree",
            keys = {
                { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle undo tree" },
            },
        },

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
            opts = {}
        },

        -- Motions ────────────────────────────────────────────────────
        {
            "folke/flash.nvim",
            event = "VeryLazy",
            opts = {
                modes = {
                    search = { enabled = true },
                    char = { enabled = true },
                },
            },
            keys = {
                { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
                { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
                { "r", mode = "o", function() require("flash").remote() end, desc = "Flash remote" },
                { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash treesitter search" },
            },
        },

        -- Perforce ─────────────────────────────────────────────────
        {
            "JGoundry/perfnvim",
            cmd = { "P4add", "P4edit", "P4opened", "P4grep", "P4next", "P4prev",
                    "P4revert", "P4revertunchanged", "P4delete", "P4submit",
                    "P4diff", "P4describe", "P4sync", "P4annotate",
                    "P4shelve", "P4unshelve", "P4login", "P4health", "P4info" },
            keys = {
                { "<leader>pa", function() require("perfnvim").P4add() end, desc = "P4 add" },
                { "<leader>pe", function() require("perfnvim").P4edit() end, desc = "P4 edit" },
                { "<leader>pr", function() require("perfnvim").P4revert() end, desc = "P4 revert buffer" },
                { "<leader>pR", function() require("perfnvim").P4revertunchanged() end, desc = "P4 revert unchanged" },
                { "<leader>pd", function() require("perfnvim").P4delete() end, desc = "P4 mark delete" },
                { "<leader>ps", function() require("perfnvim").P4submit() end, desc = "P4 submit" },
                { "<leader>pD", function() require("perfnvim").P4diff() end, desc = "P4 diff vs have" },
                { "<leader>pC", function() require("perfnvim").P4describe() end, desc = "P4 describe CL" },
                { "<leader>pS", function() require("perfnvim").P4sync() end, desc = "P4 sync" },
                { "<leader>pb", function() require("perfnvim").P4annotate() end, desc = "P4 annotate (blame)" },
                { "<leader>ph", function() require("perfnvim").P4shelve() end, desc = "P4 shelve" },
                { "<leader>pH", function() require("perfnvim").P4unshelve() end, desc = "P4 unshelve" },
                { "<leader>pl", function() require("perfnvim").P4login() end, desc = "P4 login" },
                { "<leader>pi", function() require("perfnvim").P4info() end, desc = "P4 info" },
                { "<leader>po", function() require("perfnvim").P4opened() end, desc = "P4 opened (telescope)" },
                { "<leader>pg", function() require("perfnvim").P4grep() end, desc = "Grep checked-out files" },
                { "<leader>pn", function() require("perfnvim").P4next() end, desc = "Next changed line" },
                { "<leader>pp", function() require("perfnvim").P4prev() end, desc = "Previous changed line" },
            },
            config = function()
                require("perfnvim").setup()
            end,
        },

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
