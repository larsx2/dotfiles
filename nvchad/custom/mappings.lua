---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>Q"] = { "<cmd>%bd|e#<CR>", "Close all other buffers" },
    ["<leader>U"] = { vim.cmd.only, "Keep only this window" },
    ["<leader>K"] = { vim.cmd.quit, "Kill this window" },
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

M.telescope = {
 n = {
    ["<space>fc"] = { "<cmd>e $MYVIMRC<CR>", "Open config folder" },
    ["<space>jt"] = { "<cmd>Telescope lsp_type_definitions<CR>", "Open lsp type definitions" },
    ["<space>jd"] = { "<cmd>Telescope lsp_definitions<CR>", "Open lsp definitions" },
    ["<space>jr"] = { "<cmd>Telescope lsp_references<CR>", "Open lsp references" },
    ["<space>ji"] = { "<cmd>Telescope lsp_implementations<CR>", "Open lsp implementations" },
    ["<space>fd"] = { "<cmd>Telescope find_files hidden=true<CR>", "Find files including hidden" },
    ["<space>fg"] = { "<cmd>Telescope grep_string<CR>", "Search string in buffer" },

    -- Git
    ["<space>ga"] = { "<cmd>Telescope git_branches<CR>", "See repository branches" },
    ["<space>gca"] = { "<cmd>Telescope git_commits<CR>", "See all repository commits" },
    ["<space>gcb"] = { "<cmd>Telescope git_bcommits<CR>", "See buffer commits" },
    ["<space>gs"] = { "<cmd>Telescope git_stash<CR>", "See repository stashes" },

  }
}

M.todoComments = {
  n = {
    ["<space>tc"] = { "<cmd>TodoTelescope<CR>", "Open Todo Comments in Telescope" },
    ["<space>tq"] = { "<cmd>TodoTrouble<CR>", "Open Todo Comments in Trouble" },
    ["<space>tC"] = {
      function()
        require("todo-comments").disable()
      end,
      "Disable todo comments"
    },
    ["]t"] = {
      function()
        require("todo-comments").jump_next()
      end,
      "Next todo comment",
    },
    ["[t"] = {
      function()
        require("todo-comments").jump_prev()
      end,
      "Previous todo comment",
    },
  }
}

M.nvimtree = {
  n = {
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle NvimTree" },
  }
}

M.trouble = {
  n = {
    ["<leader>q"] = { "<cmd> TroubleToggle<CR>", "Toggle Trouble" },
  }
}

M.nvterm = {
  n = {
    ["<space>tp"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },
  }
}

M.lspconfig = {
  n = {
    ["<leader>-"] = { "<cmd> split<CR>", "Open definitions in horizontal split" },
    ["<leader>_"] = { "<cmd> vsplit<CR>", "Open definitions in vertical split" },
    ["<leader>js"] = { "<cmd> split | lua vim.lsp.buf.definition()<CR>", "Open definitions in horizontal split" },
    ["<leader>jv"] = { "<cmd> vsplit | lua vim.lsp.buf.definition()<CR>", "Open definitions in vertical split" },
  }
}

M.outline = {
  n = {
    ["<leader>o"] = { "<cmd>Outline<CR>", "Open outline"}
  }
}

return M
