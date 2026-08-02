---
-- LSP configuration
---

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP Actions",
    callback = function(event)
        local opts = { buffer = event.buf }
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Navigation
        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

        -- clangd: switch source/header (guarded by client check)
        if client and client.name == "clangd" then
            vim.keymap.set("n", "<leader>h", "<cmd>ClangdSwitchSourceHeader<cr>", {
                buffer = event.buf,
                desc = "Switch Source/Header",
            })
        end
    end,
})

---
-- Lua LSP settings
---
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            runtime = { version = "LuaJIT" },
            -- Stricter formatting for Lua (like gofumpt for go)
            format = { enable = false }, -- let conform.nvim (stylua) handle it
        },
    },
})

---
-- Mason: LSP installer + auto-setup
-- NOTE: Neovim 0.11+ with blink.cmp auto-merges LSP capabilities.
-- No need to pass capabilities manually.
---
require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "clangd",
        "cmake",
        "gopls",
        "vtsls",
        "html",
        "cssls",
        "docker_language_server",
        "jsonls",
        "basedpyright", -- Python (strictest type checker, best-in-class)
    },
    handlers = {
        function(server)
            vim.lsp.config(server, {})
            vim.lsp.enable({ server })
        end,
    },
})