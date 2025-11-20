require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "terraform", "tf" },
  callback = function()
    vim.opt_local.commentstring = "# %s"
  end,
})

-- ~/.config/nvim/lua/custom/init.lua
vim.opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "context:12",
  "algorithm:histogram",
  "linematch:200",
  "indent-heuristic",
  "iwhite", -- toggle when needed
}

-- Example from docs / issues
local actions = require "telescope.actions"
require("telescope").setup {
  defaults = {
    -- ...
  },
  pickers = {
    find_files = {
      attach_mappings = function(_, map)
        map("i", "<C-j>", actions.move_selection_next)
        map("i", "<C-k>", actions.move_selection_previous)
        return true
      end,
    },
  },
}
