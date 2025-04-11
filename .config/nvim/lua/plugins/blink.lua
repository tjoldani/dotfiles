return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",

  opts = function(_, opts)
    vim.b.completion = true
    vim.b.show_snippets = false -- initially off

    local function toggle_completion()
      vim.b.completion = not vim.b.completion
      require("blink.cmp").hide()
      print("Completion " .. (vim.b.completion and "enabled" or "disabled"))
    end

    local function toggle_snippets()
      vim.b.show_snippets = not vim.b.show_snippets
      require("blink.cmp").reload()
      print("Snippets " .. (vim.b.show_snippets and "enabled" or "disabled"))
    end

    -- Keybindings
    vim.keymap.set({ "i", "n" }, "<C-q>", toggle_completion, { desc = "Toggle Completion" })
    vim.keymap.set({ "i", "n" }, "<C-s>", toggle_snippets, { desc = "Toggle Snippets" })

    -- Enable/disable completion globally
    opts.enabled = function()
      return vim.b.completion
    end

    -- Dynamically enable/disable snippet source
    opts.sources = {
      default = function()
        local sources = { "lsp", "path" }
        if vim.b.show_snippets then
          table.insert(sources, "snippets")
        end
        return sources
      end,
    }

    -- Your other options
    opts.keymap = {
      preset = "default",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
    }
    opts.appearance = {
      nerd_font_variant = "mono",
    }
    opts.completion = { documentation = { auto_show = true } }
    opts.fuzzy = { implementation = "prefer_rust_with_warning" }

    return opts
  end,

  opts_extend = { "sources.default" },
}
