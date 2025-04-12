return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "ruff" },
      html = { "htmlhint" },
      yaml = { "yamllint" },
      markdown = { "markdownlint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
      group = lint_augroup,
      callback = function()
        vim.defer_fn(function()
          lint.try_lint()
        end, 100)
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Lint current file" })
  end,
}
