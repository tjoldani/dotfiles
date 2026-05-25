return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local gitsigns = require("gitsigns")

    gitsigns.setup({
      on_attach = function(bufnr)
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", gitsigns.next_hunk, "Next hunk")
        map("n", "[h", gitsigns.prev_hunk, "Prev hunk")
        map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
        map("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
        map("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer")
        map("n", "<leader>hu", gitsigns.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer")
        map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", gitsigns.blame_line, "Blame line")
        map("n", "<leader>hd", gitsigns.diffthis, "Diff this")
      end,
    })
  end,
}
