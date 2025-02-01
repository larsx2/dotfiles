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
