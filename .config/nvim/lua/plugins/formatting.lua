return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        yaml = { "prettier" },
        markdown = { "markdownlint" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        python = { "ruff_format" },
      },

      formatters = {
        markdownlint = {
          command = vim.fn.stdpath("data") .. "/mason/bin/markdownlint",
          args = function(params)
            return { "--fix", vim.fn.fnameescape(params.filename) }
          end,
          stdin = false,
        },
      },

      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 1000,
      },
    })

    -- Manual format mapping
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({ async = false, lsp_fallback = true, timeout_ms = 1000 })
    end, { desc = "Format file or range" })
  end,
}
