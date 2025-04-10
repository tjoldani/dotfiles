local M = {}

function M.setup()
  local map = vim.keymap.set

  -- Buffers
  map("n", "<Leader>bl", ":bnext<CR>", { desc = "Open the next buffer" })
  map("n", "<Leader>bh", ":bprevious<CR>", { desc = "Open the previous buffer" })
  map("n", "<Leader>bx", ":bd<CR>", { desc = "Close the buffer" })

  -- Splits
  map("n", "<leader>sh", ":split<CR><C-w>l", { desc = "Horizontal split" })
  map("n", "<leader>sv", ":vsplit<CR><C-w>l", { desc = "Vertical split" })
  map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
  map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

  -- Tabs
  map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
  map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
  map("n", "<leader>tl", "<cmd>tabn<CR>", { desc = "Go to next tab" })
  map("n", "<leader>th", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
  map("n", "<leader>td", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

  -- Windows
  map("n", "<leader>q", ":q<CR>", { desc = "Close the window" })
  map("n", "<C-h>", "<C-w>h", { desc = "Move to left buffer" })
  map("n", "<C-l>", "<C-w>l", { desc = "Move to right buffer" })
  map("n", "<C-k>", "<C-w>k", { desc = "Move to top buffer" })
  map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom buffer" })

  -- Scrolling
  map("n", "<C-d>", "<C-d>zz", { noremap = true })
  map("n", "<C-u>", "<C-u>zz", { noremap = true })
  map("n", "N", "Nzz", { noremap = true })
  map("n", "n", "nzz", { noremap = true })

  -- Dashboard
  map("n", "<leader>gd", ":lua Snacks.dashboard()<CR>", { desc = "Go to dashboard" })

  -- Misc
  map("n", "<leader>wo", ":w<CR>", { desc = "Write the current file" })
  map("n", "<S-h>", "^", { noremap = true, silent = true }) -- Go to first char on line
  map("n", "<S-l>", "$", { noremap = true, silent = true }) -- Go to last on line
  map("i", "jj", "<Esc>", { noremap = true, silent = true }) -- Escape to normal
  map("n", "<leader>ww", function() -- Wordwrap
    vim.wo.wrap = not vim.wo.wrap
    vim.wo.linebreak = vim.wo.wrap -- Sync linebreak with wrap
    vim.wo.breakindent = vim.wo.wrap -- Keep indentation when wrapping
    print("Wrap: " .. (vim.wo.wrap and "ON" or "OFF"))
  end, { desc = "Toggle wrap + linebreak", silent = true })
end

return M
