---
-- nvim-lint: asynchronous linting, complementary to LSP diagnostics.
-- Linters are installed via Mason (:MasonInstall <name>) or system package manager.
---

local lint = require("lint")

lint.linters_by_ft = {
    -- To install: :MasonInstall selene
    lua = { "selene" },

    -- ruff handles both linting and formatting
    python = { "ruff" },

    -- Install via system: dnf install ShellCheck
    sh = { "shellcheck" },

    -- :MasonInstall hadolint
    dockerfile = { "hadolint" },

    -- :MasonInstall markdownlint
    markdown = { "markdownlint" },

    -- :MasonInstall yamllint
    yaml = { "yamllint" },
}

-- Lint on write, insert leave, and text change (debounced internally)
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "TextChanged" }, {
    group = vim.api.nvim_create_augroup("LintOnChange", { clear = true }),
    callback = function()
        lint.try_lint()
    end,
})