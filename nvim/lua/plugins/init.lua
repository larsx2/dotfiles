return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc", "python",
        "html", "css"
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    cmd = { "TodoTelescope", "TodoTrouble" },
    config = function()
      require("todo-comments").setup({})
    end,
  },

  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    lazy = false,
  },

  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
  },

  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    config = function()
      require("outline").setup({})
    end,
  },

  {
    "smoka7/hop.nvim",
    tag = "*",
    config = function()
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran"})
    end,
    lazy = false,
  },

  {
    "neoclide/coc.nvim",
    lazy = false
  }
}
