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
