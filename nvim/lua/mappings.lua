require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Buffers
vim.keymap.del("n", "<leader>b")
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Close all buffers except current" })

-- Telescope
map("n", "<leader>fe", "<cmd>Telescope diagnostics<CR>", { desc = "See errors" })
map("n", "<leader>jd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Open lsp definitions" })
map("n", "<leader>jr", "<cmd>Telescope lsp_references<CR>", { desc = "Open lsp references" })
map("n", "<leader>jt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Open lsp type definitions" })
map("n", "<leader>ji", "<cmd>Telescope lsp_implementations<CR>", { desc = "Open lsp implementations" })
map("n", "<leader>fbl", "<cmd>Telescope git_branches<CR>", { desc = "See all branches" })
map("n", "<leader>gca", "<cmd>Telescope git_commits<CR>", { desc = "See all git commits" })
map("n", "<leader>gcb", "<cmd>Telescope git_bcommits<CR>", { desc = "See buffer commits" })
map("n", "<leader>fgs", "<cmd>Telescope git_status<CR>", { desc = "See git status" })
map("n", "<leader>fst", "<cmd>Telescope git_stash<CR>", { desc = "See git stash" })

-- Hop
map("n", "<leader>jw", "<cmd>HopWord<CR>", { desc = "Hop to word" })
map("n", "<leader>jp", "<cmd>HopPattern<CR>", { desc = "Hop pattern" })
map("n", "<leader>jc", "<cmd>HopChar1<CR>", { desc = "Hop to char1" })
map("n", "<leader>jl", "<cmd>HopLine<CR>", { desc = "Hop to line" })

-- NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

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
map("n", "<leader>qs", "<cmd>Trouble symbols toggle focus=true win.size=0.4<cr>", { desc = "Symbols (Trouble)" })
map(
  "n",
  "<leader>qd",
  "<cmd>Trouble lsp toggle focus=false win.position=bottom<cr>",
  { desc = "LSP Definitions / references / ... (Trouble)" }
)
map("n", "<leader>ql", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>qf", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- LSP split navigation
map("n", "<leader>js", function()
  vim.cmd("split")
  vim.lsp.buf.definition()
end, { desc = "Open definition in horizontal split" })

map("n", "<leader>jv", function()
  vim.cmd("vsplit")
  vim.lsp.buf.definition()
end, { desc = "Open definition in vertical split" })

-- Git (fugitive)
map("n", "<leader>gC", "<cmd>Git commit<cr>", { desc = "Git commit" })
map("n", "<leader>gD", "<cmd>Gvdiffsplit<cr>", { desc = "Git diff split" })

-- Tabs
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "Create new tab" })
map("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close current tab" })
map("n", "<leader>t]", "<cmd>tabnext<cr>", { desc = "Go to next tab" })
map("n", "<leader>t[", "<cmd>tabprevious<cr>", { desc = "Go to previous tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close all tabs but the current one" })
map("n", "<leader>tf", "<cmd>tabfirst<cr>", { desc = "Go to first tab" })
map("n", "<leader>tl", "<cmd>tablast<cr>", { desc = "Go to last tab" })

-- Gitsigns
map("n", "<leader>gbla", "<cmd>Gitsigns blame<cr>", { desc = "Gitsigns blame all" })
map("n", "<leader>gbll", "<cmd>Gitsigns blame_line<cr>", { desc = "Gitsigns blame line" })
map("n", "<leader>gP", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Gitsigns preview hunk" })
map("n", "<leader>gH", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Gitsigns reset hunk" })
map("n", "<leader>gr", function()
  local choice = vim.fn.confirm("Reset entire buffer?", "&Yes\n&No", 2)
  if choice == 1 then
    require("gitsigns").reset_buffer()
  end
end, { desc = "Gitsigns reset buffer" })
map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Gitsigns stage buffer" })
map("n", "<leader>gU", "<cmd>Gitsigns reset_buffer_index<cr>", { desc = "Gitsigns unstage buffer" })

map("n", "<leader>gR", function()
  local gs = require("gitsigns")
  gs.reset_base()
  if vim.g.gitsigns_review_active then
    gs.toggle_deleted()
    gs.toggle_linehl()
    gs.toggle_numhl()
    vim.g.gitsigns_review_active = false
  end
  vim.notify("Gitsigns base reset to HEAD")
end, { desc = "Gitsigns reset base to HEAD" })

map("n", "<leader>gM", function()
  if vim.g.gitsigns_review_active then
    vim.notify("Review mode already active — use <leader>gR to reset")
    return
  end
  local gs = require("gitsigns")
  gs.change_base("origin/main")
  gs.toggle_deleted()
  gs.toggle_linehl()
  gs.toggle_numhl()
  vim.g.gitsigns_review_active = true
  vim.notify("Gitsigns base set to origin/main")
end, { desc = "Gitsigns diff vs origin/main with line highlights" })

map("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(function()
    require("gitsigns").next_hunk()
  end)
  return "<Ignore>"
end, { expr = true })

map("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    require("gitsigns").prev_hunk()
  end)
  return "<Ignore>"
end, { expr = true })

------------------
---- Diffview ----
------------------

local function get_default_branch_name()
  local res = vim.system({ "git", "rev-parse", "--verify", "main" }, { capture_output = true }):wait()
  return res.code == 0 and "main" or "master"
end

local function dv_toggle(cmd_or_fn)
  local dv = require("diffview.lib")
  if dv.get_current_view() then
    vim.cmd.DiffviewClose()
  else
    local cmd = type(cmd_or_fn) == "function" and cmd_or_fn() or cmd_or_fn
    vim.cmd(cmd)
  end
end

map("n", "<leader>dd", function()
  dv_toggle("DiffviewOpen")
end, { desc = "Toggle Diffview window" })

map("n", "<leader>dM", function()
  dv_toggle(function()
    return "DiffviewOpen origin/" .. get_default_branch_name() .. "...HEAD"
  end)
end, { desc = "Toggle Diffview vs default branch" })

map("n", "<leader>df", function()
  dv_toggle("DiffviewFileHistory %")
end, { desc = "Toggle file history (current file)" })

map("n", "<leader>dh", "<cmd>DiffviewFileHistory --follow %<cr>", { desc = "File history" })
map("v", "<leader>dl", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", { desc = "Range history" })

-- Toggle Claude Code
map("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code" })

-- Grep word under cursor
map("n", "<leader>fW", function()
  require("telescope.builtin").live_grep {
    default_text = vim.fn.expand "<cword>",
  }
end, { desc = "Live grep word under cursor" })

-- Grep word under cursor in the current buffer
map("n", "<leader>fZ", function()
  require("telescope.builtin").current_buffer_fuzzy_find {
    default_text = vim.fn.expand "<cword>",
  }
end, { desc = "Find word under cursor (current buffer)" })
