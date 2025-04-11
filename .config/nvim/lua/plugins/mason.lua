return {
  "williamboman/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup()

    require("mason-tool-installer").setup({
      ensure_installed = {
        "pyright",
        "lua-language-server",
        "html-lsp",
        "css-lsp",
        "yaml-language-server",
        "typescript-language-server",
        "bash-language-server",
        "marksman",
        "svelte-language-server",
        "prettier",
        "stylua",
        "markdownlint-cli2",
        "htmlhint",
        "ruff",
        "pylint",
        "yamllint",
      },
      auto_update = true,
      run_on_start = true,
    })
  end,
}
