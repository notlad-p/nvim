return {
  -- plugin of helpers used by other plugins
  "nvim-lua/plenary.nvim",

  -- enable repeating with supported plugins
  "tpope/vim-repeat",

  -- preview markdown in browser with command
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- run snippets of code in editor
  { "michaelb/sniprun", build = "bash ./install.sh" },

  -- sessions
  {
    "rmagatti/auto-session",
    opts = {
      log_level = "error",
      auto_restore_enabled = false,
      pre_save_cmds = {
        function()
          -- if a blank buffer exists, remove it
          local buffers = vim.api.nvim_list_bufs()
          for _, buffer in ipairs(buffers) do
            if vim.api.nvim_buf_get_name(buffer) == "" then
              vim.api.nvim_command("bwipeout! " .. buffer)
            end
          end
        end,
      },
    },
  },

  -- OpenAI chat interface - for asking questions and messing around mainly
  {
    "jackMort/ChatGPT.nvim",
    enabled = false,
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader><CR>",
        function()
          local rest = require "rest-nvim"
          rest.run()
        end,
        desc = "Run request under cursor",
      },
    },
  },
}
