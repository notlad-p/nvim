-- lightspeed.nvim : ggandor/leap.nvim
-- bufdelete.nvim : mini.bufremove
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = {
      -- "nvim-lua/plenary.nvim",
      -- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "kyazdani42/nvim-web-devicons", -- optional, for file icons
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute { toggle = true }
        end,
        desc = "File tree",
      },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    opts = {
      source_selector = {
        winbar = true,
      },
      window = {
        width = 35,
      },
      triggers = {
        { "<auto>", mode = "nixsotc" },
        { "s", mode = { "n", "v" } },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        filtered_items = {
          hide_by_name = {
            "node_modules",
          },
          always_show = {
            ".gitignore",
          },
        },
      },
    },
  },

  {
    "stevearc/oil.nvim",
    opts = {},
    keys = {
      {
        "-",
        "<CMD>Oil<CR>",
        desc = "Open parent directory",
      },
    },
    -- Optional dependencies
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      -- modes = {
      --   char = {
      --     jump_labels = true
      --   }
      -- }
    },
    -- stylua: ignore
    keys = {
      { "<leader>z", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "<leader>Z", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- {
  --   "ggandor/leap.nvim",
  --   event = "VeryLazy",
  --   config = function(_, opts)
  --     local leap = require "leap"
  --     leap.add_default_mappings(true)
  --   end,
  -- },

  -- whichkey
  {
    "max397574/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- delay = 600,
      triggers = {
        { "<auto>", mode = "nixsotc" },
        { "s", mode = { "n", "v" } },
      },
      preset = "modern",
      icons = {
        mappings = false,
      },
    },
    config = function(_, opts)
      local which_key = require "which-key"
      which_key.setup(opts)

      which_key.add({
        { "<leader>B", group = "Buffers" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP", icon = "擄" },
        { "<leader>s", group = "Search" },
        { "<leader>x", group = "Trouble", icon = " " },
        { "<leader>n", group = "Noice" },
        { "<leader>m", group = "Harpoon" },
        { "<leader><tab>", group = "Tabs" },
        { "]", group = "Next" },
        { "[", group = "Prev" },
      }, { mode = { "n", "v" } })
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    opts = {
      signcolumn = true,
      numhl = true,
    },
    keys = {
      { "]h", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Jump next hunk" },
      { "[h", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Jump prev hunk" },
      { "<leader>gB", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame line" },
      { "<leader>gD", "<cmd>lua require 'gitsigns'.toggle_deleted()<cr>", desc = "Toggle deleted lines" },
      { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset buffer" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
      { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Jump next hunk" },
      { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Jump prev hunk" },
      { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Search changed files" },
      { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview hunk" },
      { "<leader>gP", "<cmd>lua require 'gitsigns'.preview_hunk_inline()<cr>", desc = "Preview hunk inline" },
      { "<leader>gq", "<cmd>lua require 'gitsigns'.setqflist()<cr>", desc = "Quickfix list hunks" },
      { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset hunk" },
      { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage hunk" },
      { "<leader>gS", "<cmd>lua require 'gitsigns'.stage_buffer()<cr>", desc = "Stage buffer" },
      { "<leader>gt", "<cmd>lua require 'gitsigns'.diffthis()<cr>", desc = "View file diff" },
      { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo stage hunk" },
      {
        "<leader>gC",
        "<cmd>Telescope git_bcommits<cr>",
        desc = "Checkout commit(for current file)",
      },
      { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git Diff" },
    },
  },

  -- illuminate other uses of a word under cursor
  {
    "RRethy/vim-illuminate",
    event = "BufWinEnter",
    opts = {
      delay = 150,
      filetypes_denylist = {
        "NvimTree",
        "alpha",
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
    keys = {
      {
        "]]",
        function()
          require("illuminate").goto_next_reference(false)
        end,
        desc = "Next reference",
      },
      {
        "[[",
        function()
          require("illuminate").goto_prev_reference(false)
        end,
        desc = "Prev Reference",
      },
    },
  },

  -- better buffer delete
  "famiu/bufdelete.nvim",

  -- List of diagnostics
  {
    "folke/trouble.nvim",
    dependencies = "kyazdani42/nvim-web-devicons",
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle trouble" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
      { "<leader>xD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>xr", "<cmd>TroubleToggle lsp_references<cr>", desc = "LSP references" },
      { "<leader>xf", "<cmd>TroubleToggle lsp_definitions<cr>", desc = "LSP definitions" },
      { "<leader>xt", "<cmd>TroubleToggle lsp_type_definitions<cr>", desc = "LSP type definitions" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix items" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location list items" },
    },
    config = function()
      require("trouble").setup()
    end,
  },

  -- create searchable to do comments
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "BufRead",
    keys = {
      { "<leader>sT", "<cmd>TodoTelescope theme=dropdown<cr>", desc = "Todos" },
      { "<leader>xT", "<cmd>TodoTrouble<cr>", desc = "Todos" },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
    },
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- highlight color codes in editor
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },

  -- smooth scrolling & other scrolling behaviors
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end,
  },

  {
    "ziontee113/icon-picker.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "stevearc/dressing.nvim",
    },
    opts = {
      disable_legacy_commands = true,
    },
    keys = {
      { "<leader>si", "<cmd>IconPickerNormal<cr>", desc = "Find icon" },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      indent = { enabled = true },
      heading = {
        icons = { " ", " ", " ", " ", " ", " " },
      },
    },
  },
}
