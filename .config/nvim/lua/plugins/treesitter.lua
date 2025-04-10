return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
        ensure_installed = {
          "bash",
          "css",
          "lua",
          "vim",
          "vimdoc",
          "javascript",
          "html",
          "markdown",
          "markdown_inline",
          "json",
          "python",
          "typescript",
          "c",
          "query",
          "svelte",
          "norg",
          "scss",
          "tsx",
          "typst",
          "vue",
          "regex",
        },
      })
    end,
  },
}
