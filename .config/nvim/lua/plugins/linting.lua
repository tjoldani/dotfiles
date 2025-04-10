return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Define linters per filetype
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "ruff" },
      html = { "htmlhint" },
      yaml = { "yamllint" },
      markdown = { "markdownlint-cli2" },
    }

    -- Customize markdownlint args (optional: expand path manually)
    lint.linters["markdownlint-cli2"].args = {
      "--config",
      vim.fn.expand("~/.markdownlint.yaml"),
    }

    -- Autocommand group for triggering linting
    local lint_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Manual lint trigger
    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Lint current file" })
  end,
}
