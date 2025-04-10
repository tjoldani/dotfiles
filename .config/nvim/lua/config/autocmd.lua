local M = {}

function M.setup()
  -- Highlight text on yank
  vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
      vim.highlight.on_yank({ timeout = 300 })
    end,
  })
end

return M
