-- vim.opt.diffopt = {
--   "internal",
--   "filler",
--   "closeoff",
--   "context:12",
--   "algorithm:histogram",
--   "linematch:200",
--   "indent-heuristic",
--   "iwhite", -- I toggle this one, it doesn't fit all cases.
-- }
return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        javascript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        lua = { "stylua" },
        python = { "black" },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require "lint"

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      local grp = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = grp,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
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
        "vim",
        "lua",
        "vimdoc",
        "python",
        "html",
        "css",
        "graphql",
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    cmd = { "TodoTelescope", "TodoTrouble" },
    config = function()
      require("todo-comments").setup {}
    end,
  },

  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    lazy = false,
  },

  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    config = function()
      require("outline").setup {}
    end,
  },

  {
    "smoka7/hop.nvim",
    tag = "v2.7.2",
    config = function()
      require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
    end,
    lazy = false,
  },

  -- {
  --   "neoclide/coc.nvim",
  --   lazy = false,
  -- },
  {

    "sindrets/diffview.nvim", -- optional - Diff integration
    config = function()
      vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#20303b" })
      vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#37222c" })
      vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1f2231" })
      vim.api.nvim_set_hl(0, "DiffText", { bg = "#394b70" })
      require "configs.diffview"
    end,
  },
  -- {
  --   "NeogitOrg/neogit",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- required
  --     "sindrets/diffview.nvim", -- optional - Diff integration
  --
  --     -- Only one of these is needed.
  --     "nvim-telescope/telescope.nvim", -- optional
  --   },
  --   lazy = false,
  -- },
  {
    "tpope/vim-fugitive",
    lazy = false,
  },
  {
    "itsamayo/microscope.nvim",
    config = function()
      require("microscope.module").setup {
        keymaps = {
          fold = "zr",
        },
      }
    end,
    lazy = false,
  },

  {
    "MattesGroeger/vim-bookmarks",
    lazy = false,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui", "mfussenegger/nvim-dap-python" },
    config = function()
      require("dapui").setup()
      require "configs.dap"
      -- Basic config for dap can go here
    end,
    lazy = false,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-jest",
        },
      }
    end,
    lazy = false,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = function(_, opts)
      opts.filters.dotfiles = true -- hide dotfiles
      opts.view = opts.view or {}
      opts.view.width = "20%"
    end,
  },

  {
    {
      "olimorris/codecompanion.nvim",
      tag = "v17.16.0",
      config = function()
        require("codecompanion").setup {
          strategies = {
            chat = {
              adapter = "anthropic",
            },
            inline = {
              adapter = "anthropic",
            },
          },
        }
      end,
      lazy = false,
    },
  },

  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("claude-code").setup()
    end,
    lazy = false,
  },
}
