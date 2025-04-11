return {
  cmd = { "marksman", "server" },
  filetypes = { "markdown" },
  root_dir = function(fname)
    return vim.fs.root(fname, { ".git", ".obsidian" }) or vim.fn.getcwd()
  end,
  settings = {
    marksman = {
      features = {
        definition = true,
        references = true,
        hover = true,
      },
      -- Optional: specify includes if needed
      -- includes = { "/*.md", "/*.markdown" },
    },
  },
}
