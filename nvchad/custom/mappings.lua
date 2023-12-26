---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
  v = {
    [">"] = { ">gv", "indent"},
  },
}

-- more keybinds!
M.hop = {
  n = {
    ["<space>jc"] = { "<cmd>HopChar1<CR>", "Hop to word"},
    ["<space>jw"] = { "<cmd>HopWord<CR>", "Hop to word"},
    ["<space>jl"] = { "<cmd>HopLine<CR>", "Hop to line"},
    ["<space>jp"] = { "<cmd>HopPattern<CR>", "Hop to pattern"},
  }
}

return M
