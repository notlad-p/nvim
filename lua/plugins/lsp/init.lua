-- run callback on LSP attach
local on_attach = function(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      callback(client, buffer)
    end,
  })
end
-- add: neodev.nvim & remove neovim cmp source
return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {

      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      -- schemeas for autocompletion in files like `tsconfig.json` and `package.json`
      {
        "b0o/SchemaStore.nvim",
        version = false,
      },
      -- typescript helper functions
      "jose-elias-alvarez/typescript.nvim",
    },
    opts = function()
      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      return {
        -- servers to automatically install if they're not already installed
        ensure_installed = {
          "tsserver",
          "sumneko_lua",
        },
        -- extra server setup
        setup = {
          tsserver = function(_, opts)
            -- keymaps are added in `plugins/lsp/keymaps.lua`
            require("typescript").setup { server = opts }
            return true
          end,
        },
        -- LSP server settings
        servers = {
          jsonls = {
            on_new_config = function(new_config)
              new_config.settings.json.schemas = new_config.settings.json.schemas or {}
              vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
            end,
            settings = {
              json = {
                -- schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            },
          },

          tailwindcss = {
            root_dir = function(fname)
              local util = require "lspconfig/util"
              return util.root_pattern("tailwind.config.js", "tailwind.config.cjs", "tailwind.js", "tailwind.cjs")(
                fname
              )
            end,
          },

          sumneko_lua = {
            settings = {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  version = "LuaJIT",
                  path = runtime_path,
                },
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { "vim" },
                },
                workspace = {
                  library = {
                    -- Make the server aware of Neovim runtime files
                    vim.fn.expand "$VIMRUNTIME/lua",
                    vim.fn.stdpath "config" .. "/lua",
                  },
                  checkThirdParty = false,
                },
                telemetry = {
                  enable = false,
                },
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      local lspconfig = require "lspconfig"
      -- attach keybinds & format on save settings
      on_attach(function(client, buffer)
        require("plugins.lsp.format").on_attach(client, buffer)
        require("plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      -- diagnostics
      require("plugins.lsp.diagnostics").setup()

      -- hover / signature styles
      local float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
      }
      -- hover style (Shift K keybind)
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float)
      -- signatureHelp style (gs keybind)
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float)

      -- set lspconfig defaults or cmp capabilities
      -- See :help lspconfig-global-defaults
      local lsp_defaults = lspconfig.util.default_config
      lsp_defaults.capabilities =
        vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

      local handler = function(server_name)
        local server_opts = opts.servers[server_name] or {}

        lspconfig[server_name].setup(server_opts)
      end

      require("mason-lspconfig").setup { ensure_installed = opts.ensure_installed }
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      --
      -- Next, you can provide a dedicated handler for specific servers.
      -- For example, a handler override for the `rust_analyzer`:
      -- ["rust_analyzer"] = function ()
      --     require("rust-tools").setup {}
      -- end
      require("mason-lspconfig").setup_handlers { handler }
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = function()
      local null_ls = require "null-ls"

      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics

      return {
        on_attach = function(client, bufnr)
          require("plugins.lsp.format").on_attach(client, bufnr)
        end,

        -- list of current formmaters & linters
        sources = {
          -- formatters
          formatting.prettierd.with {
            -- to use with svelte install plugin globaly
            -- https://github.com/sveltejs/prettier-plugin-svelte
            extra_filetypes = { "svelte" },
          },
          formatting.stylua,
          formatting.black,
          -- linters
          diagnostics.eslint_d,
          diagnostics.luacheck,
          diagnostics.mypy,
          -- extras
          -- add typescript options to code actions menu
          require "typescript.extensions.null-ls.code-actions",
        },
      }
    end,
  },
  {

    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = {
        border = "rounded",
        icons = {
          server_installed = "✓",
          server_pending = "",
          server_uninstalled = "✗",
        },
      },
    },
  },
}
