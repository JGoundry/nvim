---
-- LSP configuration
---

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP Actions",
    callback = function(event)
        local opts = { buffer = event.buf }

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
                if c:supports_method("textDocument/switchSourceHeader") then
                    c:request("textDocument/switchSourceHeader", params,
                        function(err, result)
                            if err or not result then return end
                            -- clangd returns a plain URI string, not a Location
                            local uri = type(result) == "string" and result
                                or result.uri or result.targetUri
                            if not uri then return end
                            local bufnr = vim.uri_to_bufnr(uri)
                            if not vim.api.nvim_buf_is_loaded(bufnr) then
                                vim.fn.bufload(bufnr)
                            end
                            vim.api.nvim_set_current_buf(bufnr)
                            -- If we got a Location with a range, jump to it
                            local range = type(result) == "table" and result.range
                            if range then
                                vim.api.nvim_win_set_cursor(0, {
                                    range.start.line + 1,
                                    range.start.character,
                                })
                            end
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
            format = { enable = false },
        },
    },
})
vim.lsp.enable({ "lua_ls" })

--- Mason: auto-install LSP servers, formatters, and linters.
-- NOTE: Neovim 0.11+ with blink.cmp auto-merges LSP capabilities.
-- No need to pass capabilities manually.
-- mason-lspconfig v2.0+ uses automatic_enable = true (default),
-- so vim.lsp.enable() is called automatically for every Mason-installed
-- server. Pre-configure servers (like lua_ls above) before this setup
-- so their custom config takes effect.
--
-- System requirements (not installable via Mason):
--   dnf install ripgrep fd-find ShellCheck
--   Node.js (for prettierd, vtsls, cssls, html, jsonls)
--   Rust toolchain (rustup) for rustfmt and rust-analyzer
--   Go toolchain for gofumpt, goimports, gopls
---
require("mason").setup({
    ensure_installed = {
        "stylua",
        "gofumpt",
        "goimports",
        "prettierd",
        "clang_format",
        "ruff",
        "rustfmt",
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
        "basedpyright",
    },
})