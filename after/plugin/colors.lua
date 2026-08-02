function colorEverything(color)
    color = color or "tokyonight-night"
    vim.cmd.colorscheme(color)

    -- Transparent background (for terminal with compositor transparency)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
    vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
end

colorEverything()

-- Native highlight-on-yank (replaces vim-highlightedyank)
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Brief highlight on yank",
    callback = function()
        vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})