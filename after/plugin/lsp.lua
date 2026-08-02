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

        -- Source/header switching — uses clangd's custom method or falls
        -- back to LSP definition. Works for any server that implements
        -- textDocument/switchSourceHeader (clangd, ccls).
        vim.keymap.set("n", "<leader>h", function()
            local params = vim.lsp.util.make_text_document_params()
            for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                if c.supports_method("textDocument/switchSourceHeader") then
                    c.request("textDocument/switchSourceHeader", params,
                        function(err, result)
                            if err or not result then return end
                            local uri = result.uri or result.targetUri
                            local bufnr = vim.uri_to_bufnr(uri)
                            if not vim.api.nvim_buf_is_loaded(bufnr) then
                                vim.fn.bufload(bufnr)
                            end
                            vim.api.nvim_set_current_buf(bufnr)
                            local range = result.range
                            vim.api.nvim_win_set_cursor(0, {
                                range.start.line + 1,
                                range.start.character,
                            })
                        end)
                    return
                end
            end
            -- Fallback: try LSP definition (often works for cpp→h)
            vim.lsp.buf.definition()
        end, { buffer = event.buf, desc = "Switch source/header" })
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
-- Mason: auto-install LSP servers, formatters, and linters
-- NOTE: Neovim 0.11+ with blink.cmp auto-merges LSP capabilities.
-- No need to pass capabilities manually.
--
-- System requirements (not installable via Mason):
--   dnf install ripgrep fd-find ShellCheck  (ripgrep + fd for telescope, shellcheck for bash linting)
--   Node.js (for prettierd, vtsls, cssls, html, jsonls)
--   Rust toolchain (rustup) for rustfmt and rust-analyzer
--   Go toolchain for gofumpt, goimports, gopls
---
require("mason").setup({
    ensure_installed = {
        -- Formatters (for conform.nvim)
        "stylua",
        "gofumpt",
        "goimports",
        "prettierd",
        "clang_format",
        "ruff", -- also used by nvim-lint for Python
        "rustfmt",

        -- Linters (for nvim-lint)
        "selene",
        "hadolint",
        "markdownlint",
        "yamllint",
    },
})
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