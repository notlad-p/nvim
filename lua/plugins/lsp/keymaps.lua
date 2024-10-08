local M = {}

-- taken from LazyVim: https://github.com/LazyVim/LazyVim
M.diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

-- lsp keybinds
local buffer_mappings = {
  normal_mode = {
    ["K"] = { vim.lsp.buf.hover, "Show hover" },
    ["gd"] = { vim.lsp.buf.definition, "Go to Definition" },
    ["gD"] = { vim.lsp.buf.declaration, "Go to declaration" },
    ["gr"] = { vim.lsp.buf.references, "Go to references" },
    ["gI"] = { vim.lsp.buf.implementation, "Go to Implementation" },
    ["gs"] = { vim.lsp.buf.signature_help, "Show signature help" },
    ["gl"] = {
      function()
        vim.diagnostic.open_float(0)
      end,
      "Show line diagnostics",
    },
    ["gt"] = { require("plugins.lsp.format").toggle, "Toggle format on save" },

    ["<leader>la"] = { vim.lsp.buf.code_action, "Code Action" },
    ["<leader>ld"] = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Buffer Diagnostics" },
    ["<leader>lD"] = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
    ["<leader>lf"] = { "<cmd>lua vim.lsp.buf.format({ buf = vim.api.nvim_get_current_buf() })<cr>", "Format" },
    ["<leader>li"] = { "<cmd>LspInfo<cr>", "Lsp Info" },
    ["<leader>lj"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
    ["<leader>lk"] = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
    ["<leader>ll"] = { vim.lsp.codelens.run, "CodeLens Action" },
    ["<leader>lt"] = { "<cmd>Telescope lsp_type_definitions<cr>", "Type Definition" },
    ["<leader>ln"] = { vim.lsp.buf.definition, "Goto Definition" },
    ["<leader>lq"] = { vim.diagnostic.setloclist, "Quickfix" },
    ["<leader>lr"] = { vim.lsp.buf.rename, "Rename" },
    ["<leader>lR"] = { "<cmd>Telescope lsp_references<cr>", "References" },
    ["<leader>ls"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    ["<leader>lS"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
    ["<leader>le"] = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },

    ["]d"] = { M.diagnostic_goto(true), "Next Diagnostic" },
    ["[d"] = { M.diagnostic_goto(false), "Prev Diagnostic" },
    ["]e"] = { M.diagnostic_goto(true, "ERROR"), "Next Error" },
    ["[e"] = { M.diagnostic_goto(false, "ERROR"), "Prev Error" },
    ["]w"] = { M.diagnostic_goto(true, "WARN"), "Next Warning" },
    ["[w"] = { M.diagnostic_goto(false, "WARN"), "Prev Warning" },
  },
  insert_mode = {},
  visual_mode = { ["<leader>f"] = { function() vim.lsp.buf.format() end, "Format" } },
}

-- typescript mappings
local ts_mappings = {
  normal_mode = {
    ["<leader>ja"] = { require("typescript").actions.addMissingImports, "Add missing imports" },
    ["<leader>jo"] = { require("typescript").actions.organizeImports, "Organize imports" },
    ["<leader>jr"] = { require("typescript").actions.removeUnused, "Remove unused variables" },
    ["<leader>jf"] = { require("typescript").actions.fixAll, "Fix all" },
  },
  insert_mode = {},
  visual_mode = {},
}

local function add_lsp_buffer_keybindings(bufnr, keys)
  local mappings = {
    normal_mode = "n",
    insert_mode = "i",
    visual_mode = "v",
  }

  -- loops through modes & mappings and adds them
  for mode_name, mode_char in pairs(mappings) do
    for key, remap in pairs(keys[mode_name]) do
      local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
      vim.keymap.set(mode_char, key, remap[1], opts)
    end
  end
end

-- Funciton run on lsp attach
M.on_attach = function(client, bufnr)
  add_lsp_buffer_keybindings(bufnr, buffer_mappings)

  if client.name == "ts_ls" then
    add_lsp_buffer_keybindings(bufnr, ts_mappings)
  end
end

return M
