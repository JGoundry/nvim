---
-- Show marks (ma-mz) in the sign column.
-- Pure Neovim Lua — no plugin needed. ~30 lines.
---

-- Register one sign per lowercase letter (a-z)
for i = 1, 26 do
    local letter = string.char(96 + i)
    vim.fn.sign_define("Mark" .. letter, {
        text = letter,
        texthl = "DiagnosticHint",
    })
end

local function refresh_marks(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_valid(bufnr) then return end
    if not vim.api.nvim_buf_is_loaded(bufnr) then return end

    -- Clear all mark signs for this buffer
    vim.fn.sign_unplace("Marks", { buffer = bufnr })

    -- Place a sign at each lowercase mark
    local marks = vim.fn.getmarklist(bufnr)
    for _, mark in ipairs(marks) do
        local name = mark.mark:sub(2) -- strip leading '
        if #name == 1 and name:match("[a-z]") then
            vim.fn.sign_place(0, "Marks", "Mark" .. name, bufnr, {
                lnum = mark.pos[2],
                priority = 10,
            })
        end
    end
end

-- Refresh on relevant events
vim.api.nvim_create_autocmd({ "CursorHold", "BufEnter", "BufWinEnter", "BufReadPost" }, {
    group = vim.api.nvim_create_augroup("MarkSigns", { clear = true }),
    callback = function(args)
        refresh_marks(args.buf)
    end,
})