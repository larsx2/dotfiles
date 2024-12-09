require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Telescope
map("n", "<space>fe", "<cmd>Telescope diagnostics<CR>", { desc = "See issues" })
map("n", "<space>fr", "<cmd>Telescope oldfiles<CR>", { desc = "See old files" })
map("n", "<space>jd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Open lsp definiions" })
map("n", "<space>jr", "<cmd>Telescope lsp_references<CR>", { desc = "Open lsp references" })
map("n", "<space>jt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Open lsp type definitions" })
map("n", "<space>ji", "<cmd>Telescope lsp_implementations<CR>", { desc = "Open lsp implementations" })
map("n", "<space>ga", "<cmd>Telescope git_branches<CR>", { desc = "See all branches" })
map("n", "<space>gca", "<cmd>Telescope git_commits<CR>", { desc = "See all git commits" })
map("n", "<space>gcb", "<cmd>Telescope git_bcommits<CR>", { desc = "See buffer commits" })
map("n", "<space>gs", "<cmd>Telescope git_stash<CR>", { desc = "See git stash" })

-- Hop
map("n", "<space>jw", "<cmd>HopWord<CR>", { desc = "Hop to word" })
map("n", "<space>jp", "<cmd>HopPattern<CR>", { desc = "Hop pattern" })
map("n", "<space>jc", "<cmd>HopChar1<CR>", { desc = "Hop to char1" })
map("n", "<space>jl", "<cmd>HopLine<CR>", { desc = "Hop to line" })

-- NvimTree
map("n", "<leader>e", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle NvimTree" })

-- Outline
map("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Open outline" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references / ... (Trouble)" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
