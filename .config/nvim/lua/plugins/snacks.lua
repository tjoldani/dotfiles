return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          pick = nil,
          keys = {
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "f", desc = "Smart Search", action = ":lua Snacks.dashboard.pick('smart')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", padding = 2 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 0, padding = 2, limit = 5 },
          { icon = " ", title = "Projects", section = "projects", indent = 0, padding = 2, session = false, dirs = { "/home/tj/Documents/Home/", "/mnt/ha/", "/home/tj/.config/hypr/" } },
          { section = "startup" },
        },
      },
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
      indent = { enabled = true },
      input = { enabled = true },
      image = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 4000,
      },
      picker = {
        enabled = true,
        matcher = {
          frecency = true,
        },
        win = {
          input = {
            keys = {
              -- Close picker with ESC instead of going to normal mode
              ["<ESC>"] = { "close", mode = { "n", "i" } },
              -- Scroll the preview window
              ["J"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["K"] = { "preview_scroll_up", mode = { "i", "n" } },
            },
          },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notifications = {
          wo = { wrap = true },
        },
      },
    },

    keys = {
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers({
            current = true,
            sort_lastused = true,
            win = {
              input = {
                keys = { ["x"] = "bufdelete" },
              },
              list = { keys = { ["x"] = "bufdelete" } },
            },
          })
        end,
        desc = "Buffers",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Configs",
      },
      {
        "<leader>fo",
        function()
          local path = vim.fn.expand("~/Obsidian/Home")
          require("snacks").picker.files({ cwd = path })
        end,
        desc = "Obsidian",
      },
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen",
      },
      {
        "<c-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Terminal",
      },
    },
  },
}
