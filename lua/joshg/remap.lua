-- Function to move lines up
function MoveLinesUp()
  -- Get the current line and visual selection
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local current_line = cursor_pos[1]

  -- Ensure start_line is less than end_line
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  -- Move lines up
  if start_line > 1 then
    vim.cmd(string.format(":%d,%d move -2", start_line, end_line))
    -- Move cursor to the new position after moving
    vim.api.nvim_win_set_cursor(0, { current_line - 1, 0 })
  end
end

-- Function to move lines down
function MoveLinesDown()
  -- Get the current line and visual selection
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local current_line = cursor_pos[1]

  -- Ensure start_line is less than end_line
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  -- Move lines down
  local total_lines = vim.fn.line("$")
  if end_line < total_lines then
    vim.cmd(string.format(":%d,%d move +1", start_line, end_line))
    -- Move cursor to the new position after moving
    vim.api.nvim_win_set_cursor(0, { current_line + 1, 0 })
  end
end

-- Leader key and :Ex map
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Key mappings in normal mode and visual mode
vim.api.nvim_set_keymap('n', '<M-j>', [[:lua MoveLinesDown()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-k>', [[:lua MoveLinesUp()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<M-j>', [[:lua MoveLinesDown()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<M-k>', [[:lua MoveLinesUp()<CR>]], { noremap = true, silent = true })

