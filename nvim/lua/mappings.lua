require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local gs = require "gitsigns"

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Buffers
vim.keymap.del("n", "<leader>b")
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Close all buffers except current" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Telescope
map("n", "<space>fe", "<cmd>Telescope diagnostics<CR>", { desc = "See errors" })
map("n", "<space>jd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Open lsp definiions" })
map("n", "<space>jr", "<cmd>Telescope lsp_references<CR>", { desc = "Open lsp references" })
map("n", "<space>jt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Open lsp type definitions" })
map("n", "<space>ji", "<cmd>Telescope lsp_implementations<CR>", { desc = "Open lsp implementations" })
map("n", "<space>fbl", "<cmd>Telescope git_branches<CR>", { desc = "See all branches" })
map("n", "<space>gca", "<cmd>Telescope git_commits<CR>", { desc = "See all git commits" })
map("n", "<space>gcb", "<cmd>Telescope git_bcommits<CR>", { desc = "See buffer commits" })
map("n", "<space>fgs", "<cmd>Telescope git_status<CR>", { desc = "See git status" })
map("n", "<space>fst", "<cmd>Telescope git_stash<CR>", { desc = "See git stash" })

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
map("n", "<leader>qs", "<cmd>Trouble symbols toggle focus=true win.size=0.4<cr>", { desc = "Symbols (Trouble)" })
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

-- Git
map("n", "<leader>gC", "<cmd>Git commit<cr>", { desc = "Gitsigns blame all" })
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
map("n", "<leader>gn", "<cmd>Gitsigns next_hunk<cr>", { desc = "Gitsigns next hunk" })
map("n", "<leader>gp", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Gitsigns prev hunk" })
map("n", "<leader>gP", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Gitsigns preview hunk" })
map("n", "<leader>gH", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Gitsigns reset hunk" })
-- map("n", "<leader>gr", "<cmd>Gitsigns reset_buffer<cr>", { desc = "Gitsigns reset buffer" })
map("n", "<leader>gr", function()
  local choice = vim.fn.confirm("Reset entire buffer?", "&Yes\n&No", 2)
  if choice == 1 then
    gs.reset_buffer()
  end
end, { desc = "Gitsigns reset buffer" })
map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Gitsigns stage buffer" })
map("n", "<leader>gU", "<cmd>Gitsigns reset_buffer_index<cr>", { desc = "Gitsigns unstage buffer" })
local gm_review_active = false
map("n", "<leader>gR", function()
  gs.reset_base()
  if gm_review_active then
    gs.toggle_deleted()
    gs.toggle_linehl()
    gs.toggle_numhl()
    gm_review_active = false
  end
  vim.notify "Gitsigns base reset to HEAD"
end, { desc = "Gitsigns reset base to HEAD" })
map("n", "<leader>gM", function()
  if gm_review_active then
    vim.notify "Review mode already active — use <leader>gR to reset"
    return
  end
  gs.change_base "origin/main"
  gs.toggle_deleted()
  gs.toggle_linehl()
  gs.toggle_numhl()
  gm_review_active = true
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

------------------
---- Diffview ----
------------------
local dv = require "diffview.lib"
map("n", "<leader>dd", function()
  if next(dv.views) == nil then
    vim.cmd "DiffviewOpen"
  else
    vim.cmd "DiffviewClose"
  end
end, {
  desc = "Toggle Diffview window",
})

map("n", "<leader>dM", function()
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

-- Diffview
map("n", "<leader>do", "<cmd>DiffviewOpen<cr>", { desc = "Repo diff" })
map("n", "<leader>dc", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })

local function get_default_branch_name()
  local res = vim.system({ "git", "rev-parse", "--verify", "main" }, { capture_output = true }):wait()
  return res.code == 0 and "main" or "master"
end

local function dv_toggle(cmd_or_fn)
  if dv.get_current_view() then
    vim.cmd.DiffviewClose()
  else
    local cmd = type(cmd_or_fn) == "function" and cmd_or_fn() or cmd_or_fn
    vim.cmd(cmd)
  end
end

-- mappings (examples)
map("n", "<leader>dM", function()
  dv_toggle(function()
    return "DiffviewOpen origin/" .. get_default_branch_name() .. "...HEAD"
  end)
end, { desc = "Toggle Diffview vs default branch" })

map("n", "<leader>df", function()
  dv_toggle "DiffviewFileHistory %"
end, { desc = "Toggle file history (current file)" })

-- map("v", "<leader>dr", function()
--   dv_toggle(function()
--     return "DiffviewFileHistory --follow"
--   end)
-- end, { desc = "Toggle file history (default..HEAD)" })

map("n", ",hf", "<cmd>DiffviewFileHistory --follow %<cr>", { desc = "File history" })
map("v", "<leader>dl", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", { desc = "Range history" })

-- grep word under cursor
map("n", "<leader>fW", function()
  require("telescope.builtin").live_grep {
    default_text = vim.fn.expand "<cword>",
  }
end, { desc = "Live grep word under cursor" })

-- grep word under cursor in the current buffer
map("n", "<leader>fZ", function()
  require("telescope.builtin").current_buffer_fuzzy_find {
    default_text = vim.fn.expand "<cword>",
  }
end, { desc = "Find word under cursor (current buffer)" })
