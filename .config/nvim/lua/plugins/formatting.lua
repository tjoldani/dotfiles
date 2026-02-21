return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        yaml = { "prettier" },
        markdown = { "markdownlint-cli2", "prettier" },
        lua = { "stylua" },
        python = { "ruff_format" },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 1000,
      },
    })
  end,
}
