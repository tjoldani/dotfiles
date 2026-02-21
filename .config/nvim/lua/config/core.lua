--UI
vim.opt.ruler = false -- Disable extra numbering
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.numberwidth = 4
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.termguicolors = true -- Enable true colors
vim.opt.background = "dark" -- Set colorschemes to dark
vim.opt.signcolumn = "yes" -- Show sign column so text doesn't shift
vim.opt.showmode = false -- Uneeded due to Lualine
vim.opt.wrap = true -- Enable word wrap
vim.opt.linebreak = true -- Wrap at words instead of letters.
vim.opt.swapfile = false -- Annoying
vim.opt.cursorline = true -- Highlight current line
vim.opt.ttyfast = true -- Faster scrolling
vim.opt.smoothscroll = true -- Like butter
vim.opt.scrolloff = 0 -- Keep cursor in middle when scrolling - 0 to disable
vim.opt.mouse = "a" -- Enable mouse
vim.opt.history = 100 -- Command line history
vim.opt.splitkeep = "screen" -- Stabalize window open/close
vim.opt.splitbelow = true -- Open help split below current instead of above
vim.opt.splitright = true -- Open splits to right by default
-- vim.opt.colorcolumn = "90" -- Add a column guide
vim.opt.virtualedit = "block" -- Visual select can move beyond characters

-- Indentation
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, eol, and insert mode start position
vim.opt.expandtab = true -- Converts tabs to spaces
vim.opt.shiftwidth = 2 -- Number of spaces for indentation
vim.opt.tabstop = 2 -- Number of spaces per tab
vim.opt.softtabstop = 2 -- Spaces when hitting <Tab>
vim.opt.smartindent = true -- Auto-indent based on syntax
vim.opt.list = true
vim.cmd([[
  highlight NonText guifg=#FFA500
  highlight Whitespace guifg=#FFA500
  highlight link Whitespace NonText
]])

-- Searching
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case-sensitive if uppercase letters used
vim.opt.hlsearch = false -- Highlight search results
vim.opt.incsearch = true -- Highlight matches while tying
vim.opt.inccommand = "split" -- Split %s into sub window

-- LSP Warnings
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostics" })
