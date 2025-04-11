return {
  "saghen/blink.cmp",
  -- Optional: Provides snippets for the snippet source
  dependencies = { "rafamadriz/friendly-snippets" },

  -- Use a release tag to download pre-built binaries
  version = "1.*",
  -- OR build from source (requires nightly Rust)
  -- build = 'cargo build --release',

  opts = {
    keymap = {
      preset = "default",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono", -- 'mono' for 'Nerd Font Mono', 'normal' for 'Nerd Font'
    },
    completion = { documentation = { auto_show = true } },
    sources = {
      default = { "lsp", "path", "snippets" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
