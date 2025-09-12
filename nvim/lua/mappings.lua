require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local gs = require "gitsigns"

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
map("n", "<space>gz", "<cmd>Telescope git_stash<CR>", { desc = "See git stash" })

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
map("n", "<leader>qq", "<cmd>Trouble diagnostics toggle focus=true<cr>", { desc = "Diagnostics (Trouble)" })
map(
  "n",
  "<leader>qb",
  "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
  { desc = "Buffer Diagnostics (Trouble)" }
)
map("n", "<leader>qs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map(
  "n",
  "<leader>qd",
  "<cmd>Trouble lsp toggle focus=false win.position=bottom<cr>",
  { desc = "LSP Definitions / references / ... (Trouble)" }
)
map("n", "<leader>ql", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>qf", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

map(
  "n",
  "<leader>js",
  "<cmd> split | lua vim.lsp.buf.definition()<CR>",
  { desc = "Open definition in horizontal split" }
)
map(
  "n",
  "<leader>jv",
  "<cmd> vsplit | lua vim.lsp.buf.definition()<CR>",
  { desc = "Open definition in vertical split" }
)

-- Tabs
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "Create new tab" })
map("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close current tab" })
map("n", "<leader>t]", "<cmd>tabnext<cr>", { desc = "Go to next tab" })
map("n", "<leader>t[", "<cmd>tabprevious<cr>", { desc = "Go to previous tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close all tabs but the current one" })
map("n", "<leader>tf", "<cmd>tabfirst<cr>", { desc = "Go to first tab" })
map("n", "<leader>tl", "<cmd>tablast<cr>", { desc = "Go to last tab" })

-- Gitsigns
map("n", "<leader>gba", "<cmd>Gitsigns blame<cr>", { desc = "Gitsigns blame all" })
map("n", "<leader>gbl", "<cmd>Gitsigns blame_line<cr>", { desc = "Gitsigns blame line" })
map("n", "<leader>gn", "<cmd>Gitsigns next_hunk<cr>", { desc = "Gitsigns next hunk" })
map("n", "<leader>gp", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Gitsigns prev hunk" })
map("n", "<leader>gP", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Gitsigns preview hunk" })
map("n", "<leader>gH", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Gitsigns reset hunk" })
map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Gitsigns reset buffer" })
map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Gitsigns stage buffer" })
map("n", "<leader>gU", "<cmd>Gitsigns reset_buffer_index<cr>", { desc = "Gitsigns unstage buffer" })
map("n", "<leader>gD", "<cmd>Gitsigns diffthis<cr>", { desc = "Gitsigns diff buffer" })
map("n", "<leader>gR", "<cmd>Gitsigns reset_base<cr>", { desc = "Gitsigns reset base to HEAD" })
map("n", "<leader>gB", function()
  gs.change_base "origin/main"
  gs.toggle_deleted()
  gs.toggle_linehl()
  gs.toggle_numhl()
  vim.notify "Gitsigns base set to origin/main"
end, { desc = "Gitsigns diff vs origin/main with line highlights" })

map("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(function()
    gs.next_hunk()
  end)
  return "<Ignore>"
end, { expr = true })

map("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    gs.prev_hunk()
  end)
  return "<Ignore>"
end, { expr = true })
map("n", "<leader>dv", function()
  if next(require("diffview.lib").views) == nil then
    vim.cmd "DiffviewOpen"
  else
    vim.cmd "DiffviewClose"
  end
end, {
  desc = "Toggle Diffview window",
})

map("n", "<leader>dp", function()
  local dv = require "diffview.lib"
  if next(dv.views) == nil then
    vim.cmd "DiffviewOpen origin/main...HEAD"
  else
    vim.cmd "DiffviewClose"
  end
end, {
  desc = "Toggle Diffview vs origin/main",
})

-- Function selection
map("v", "aP", "V$%", { desc = "Visual select: V + $ + %" })

-- Toggle Claude Code
map("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code" })
