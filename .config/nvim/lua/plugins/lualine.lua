return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")

    lualine.setup({
      options = {
        theme = auto,
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_z = {
          function()
            return os.date("%I:%M %p") -- 12-hour format with AM/PM
          end,
        },
      },
    })
  end,
}
