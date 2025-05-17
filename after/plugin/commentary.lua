-- Set the commentstring for C, C++, and header files
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "h", "hpp" },
    callback = function()
        vim.bo.commentstring = "// %s"
    end,
})
