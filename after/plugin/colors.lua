function colorEverything(color)
    color = color or 'tokyonight-night'
    vim.cmd.colorscheme(color)

    -- Create transparent background
    -- 0 for global space
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })
end

colorEverything()
